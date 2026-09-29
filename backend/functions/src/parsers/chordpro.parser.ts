export interface ParsedSongResult {
  title: string;
  artist: string;
  key?: string;
  tempo?: number;
  timeSignature?: string;
  capo?: number;
  chordProContent: string;
  sourceUrl?: string;
  attribution?: string;
}

export function parseChordPro(content: string, sourceUrl?: string): ParsedSongResult {
  let title = 'Untitled Song';
  let artist = 'Unknown Artist';
  let key: string | undefined;
  let tempo: number | undefined;
  let timeSignature: string | undefined;
  let capo: number | undefined;

  const lines = content.split(/\r?\n/);
  for (const line of lines) {
    const trimmed = line.trim();
    const tagMatch = trimmed.match(/^\{([a-zA-Z0-9_\-]+)(?::\s*(.*?))?\}$/);
    if (tagMatch) {
      const tag = tagMatch[1].toLowerCase();
      const val = tagMatch[2]?.trim() || '';
      if (tag === 'title' || tag === 't') title = val;
      if (tag === 'artist' || tag === 'a') artist = val;
      if (tag === 'key' || tag === 'k') key = val;
      if (tag === 'tempo' || tag === 'bpm') tempo = parseInt(val, 10);
      if (tag === 'time') timeSignature = val;
      if (tag === 'capo') capo = parseInt(val, 10);
    }
  }

  return {
    title,
    artist,
    key,
    tempo: isNaN(tempo as any) ? undefined : tempo,
    timeSignature,
    capo: isNaN(capo as any) ? 0 : capo,
    chordProContent: content,
    sourceUrl,
    attribution: sourceUrl ? `Imported from ${sourceUrl}` : undefined,
  };
}
