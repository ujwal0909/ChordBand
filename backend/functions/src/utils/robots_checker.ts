import axios from 'axios';
import robotsParser from 'robots-parser';

export async function isUrlAllowedByRobots(targetUrl: string, userAgent = 'ChordBandImporter/1.0'): Promise<boolean> {
  try {
    const parsedUrl = new URL(targetUrl);
    const robotsUrl = `${parsedUrl.protocol}//${parsedUrl.host}/robots.txt`;

    const response = await axios.get(robotsUrl, {
      timeout: 4000,
      headers: { 'User-Agent': userAgent },
      validateStatus: () => true, // Don't throw on 404
    });

    if (response.status === 200 && typeof response.data === 'string') {
      const robots = robotsParser(robotsUrl, response.data);
      const isAllowed = robots.isAllowed(targetUrl, userAgent);
      return isAllowed !== false; // If undefined or true, allowed
    }

    // If robots.txt doesn't exist (404), crawling is permitted
    return true;
  } catch (error) {
    // If robots.txt cannot be reached, allow by default
    return true;
  }
}
