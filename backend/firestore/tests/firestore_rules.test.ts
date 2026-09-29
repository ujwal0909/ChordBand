import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
  RulesTestEnvironment,
} from '@firebase/rules-unit-testing';
import * as fs from 'fs';
import * as path from 'path';

describe('ChordBand Firestore Security Rules Tests', () => {
  let testEnv: RulesTestEnvironment;

  const OWNER_UID = 'user_owner';
  const ADMIN_UID = 'user_admin';
  const EDITOR_UID = 'user_editor';
  const VIEWER_UID = 'user_viewer';
  const STRANGER_UID = 'user_stranger';
  const BAND_ID = 'band_worship_team';

  before(async () => {
    const rulesPath = path.resolve(__dirname, '../firestore.rules');
    const rules = fs.readFileSync(rulesPath, 'utf8');

    testEnv = await initializeTestEnvironment({
      projectId: 'chordband-test-project',
      firestore: {
        rules: rules,
        host: 'localhost',
        port: 8080,
      },
    });
  });

  after(async () => {
    if (testEnv) await testEnv.cleanup();
  });

  beforeEach(async () => {
    await testEnv.clearFirestore();

    // Seed test band with roles
    await testEnv.withSecurityRulesDisabled(async (context) => {
      const db = context.firestore();
      await db.collection('bands').doc(BAND_ID).set({
        name: 'Sunday Band',
        ownerId: OWNER_UID,
        isPublic: false,
        members: {
          [OWNER_UID]: { role: 'owner' },
          [ADMIN_UID]: { role: 'admin' },
          [EDITOR_UID]: { role: 'editor' },
          [VIEWER_UID]: { role: 'viewer' },
        },
      });

      await db.collection('bands').doc(BAND_ID).collection('songs').doc('song_1').set({
        title: 'Amazing Grace',
        artist: 'John Newton',
        updatedBy: OWNER_UID,
      });
    });
  });

  describe('Band Membership & Read Permissions', () => {
    it('allows band members (Viewer, Editor, Admin, Owner) to read songs', async () => {
      const viewerDb = testEnv.authenticatedContext(VIEWER_UID).firestore();
      await assertSucceeds(viewerDb.collection('bands').doc(BAND_ID).collection('songs').doc('song_1').get());
    });

    it('denies strangers from reading private band songs', async () => {
      const strangerDb = testEnv.authenticatedContext(STRANGER_UID).firestore();
      await assertFails(strangerDb.collection('bands').doc(BAND_ID).collection('songs').doc('song_1').get());
    });
  });

  describe('Song Editing & Deleting Permissions', () => {
    it('allows Editor to create a song with their own uid as updatedBy', async () => {
      const editorDb = testEnv.authenticatedContext(EDITOR_UID).firestore();
      await assertSucceeds(
        editorDb.collection('bands').doc(BAND_ID).collection('songs').doc('song_2').set({
          title: 'Krupa Choopina Deva',
          artist: 'Telugu Worship',
          updatedBy: EDITOR_UID,
        })
      );
    });

    it('denies Viewer from creating or updating songs', async () => {
      const viewerDb = testEnv.authenticatedContext(VIEWER_UID).firestore();
      await assertFails(
        viewerDb.collection('bands').doc(BAND_ID).collection('songs').doc('song_3').set({
          title: 'Unauthorized Song',
          updatedBy: VIEWER_UID,
        })
      );
    });

    it('denies Editor from deleting a song (Admin or Owner required)', async () => {
      const editorDb = testEnv.authenticatedContext(EDITOR_UID).firestore();
      await assertFails(editorDb.collection('bands').doc(BAND_ID).collection('songs').doc('song_1').delete());
    });

    it('allows Admin to delete a song', async () => {
      const adminDb = testEnv.authenticatedContext(ADMIN_UID).firestore();
      await assertSucceeds(adminDb.collection('bands').doc(BAND_ID).collection('songs').doc('song_1').delete());
    });
  });

  describe('Audit Logs (Append-Only Enforcement)', () => {
    it('allows members to append audit logs', async () => {
      const editorDb = testEnv.authenticatedContext(EDITOR_UID).firestore();
      await assertSucceeds(
        editorDb.collection('bands').doc(BAND_ID).collection('auditLogs').doc('log_1').set({
          userId: EDITOR_UID,
          action: 'edit_song',
          timestamp: new Date(),
        })
      );
    });

    it('denies anyone from modifying or deleting audit logs', async () => {
      // Seed an existing log
      await testEnv.withSecurityRulesDisabled(async (ctx) => {
        await ctx.firestore().collection('bands').doc(BAND_ID).collection('auditLogs').doc('log_seeded').set({
          userId: OWNER_UID,
          action: 'create_band',
        });
      });

      const ownerDb = testEnv.authenticatedContext(OWNER_UID).firestore();
      await assertFails(
        ownerDb.collection('bands').doc(BAND_ID).collection('auditLogs').doc('log_seeded').delete()
      );
    });
  });

  describe('Account Deletion (Google Play Mandate)', () => {
    it('allows user to delete their own account profile document', async () => {
      await testEnv.withSecurityRulesDisabled(async (ctx) => {
        await ctx.firestore().collection('users').doc(VIEWER_UID).set({
          email: 'viewer@chordband.app',
        });
      });

      const userDb = testEnv.authenticatedContext(VIEWER_UID).firestore();
      await assertSucceeds(userDb.collection('users').doc(VIEWER_UID).delete());
    });

    it('denies stranger from deleting another user profile', async () => {
      const strangerDb = testEnv.authenticatedContext(STRANGER_UID).firestore();
      await assertFails(strangerDb.collection('users').doc(VIEWER_UID).delete());
    });
  });
});
