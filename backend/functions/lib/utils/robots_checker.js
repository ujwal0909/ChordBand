"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.isUrlAllowedByRobots = isUrlAllowedByRobots;
const axios_1 = __importDefault(require("axios"));
const robots_parser_1 = __importDefault(require("robots-parser"));
async function isUrlAllowedByRobots(targetUrl, userAgent = 'ChordBandImporter/1.0') {
    try {
        const parsedUrl = new URL(targetUrl);
        const robotsUrl = `${parsedUrl.protocol}//${parsedUrl.host}/robots.txt`;
        const response = await axios_1.default.get(robotsUrl, {
            timeout: 4000,
            headers: { 'User-Agent': userAgent },
            validateStatus: () => true, // Don't throw on 404
        });
        if (response.status === 200 && typeof response.data === 'string') {
            const robots = (0, robots_parser_1.default)(robotsUrl, response.data);
            const isAllowed = robots.isAllowed(targetUrl, userAgent);
            return isAllowed !== false; // If undefined or true, allowed
        }
        // If robots.txt doesn't exist (404), crawling is permitted
        return true;
    }
    catch (error) {
        // If robots.txt cannot be reached, allow by default
        return true;
    }
}
//# sourceMappingURL=robots_checker.js.map