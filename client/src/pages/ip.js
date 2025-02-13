const ip = process.env.REACT_APP_SERVER_IP || 'localhost';
const port = process.env.REACT_APP_SERVER_PORT || '8800';
export const API_BASE_URL = `http://${ip}:${port}/api`;