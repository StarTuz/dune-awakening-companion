# Analyzing Wireshark Capture

## What You Found

You found a connection to `funcom.pubsub.iegcom.com` - this is likely a WebSocket or pub/sub connection, but we need to find the actual HTTP API calls.

## Next Steps in Wireshark

### Step 1: Look for HTTP Requests

1. **In the filter box**, type: `http.request`
2. This will show only HTTP GET/POST requests
3. Look for requests that might be API calls

### Step 2: Follow the TCP Stream

1. **Right-click** on one of the TLS/HTTP packets (like packet 3896 or 3900)
2. Select **"Follow" → "TCP Stream"**
3. This will show the decrypted conversation
4. Look for:
   - HTTP GET/POST requests
   - URLs with `/api/` or `/servers`
   - JSON responses

### Step 3: Look for JSON Data

1. **In the filter box**, type: `http contains "server" or http contains "region" or http contains "api"`
2. Or type: `json`
3. This might show JSON responses

### Step 4: Check Application Data Packets

The TLS connection might be carrying API calls. Try:

1. **Right-click** on packet 3900 (or any Application Data packet)
2. **Follow TCP Stream**
3. Look for readable text/JSON in the stream

## Alternative: Look for More Connections

The pubsub connection might not be the API. Look for:

1. **Other connections** around the same time
2. **HTTP requests** (not just TLS)
3. **Different domains** that might be API endpoints

## What to Look For

In the TCP stream or HTTP requests, you should see:

- **Request URL**: Something like `/api/servers` or `/dune-awakening/servers`
- **Host header**: The domain name
- **Response**: JSON with server data like:
  ```json
  {
    "regions": [...],
    "servers": [...]
  }
  ```

## If You See Encrypted Data

If the TCP stream shows encrypted/garbled text, the API might be:
1. Using HTTPS (encrypted) - we need to decrypt it
2. Using WebSocket - we need to decode the WebSocket frames
3. Using a custom protocol

In that case, we might need to:
- Look for unencrypted HTTP requests first
- Or check if there are other connections happening

## Quick Check

Try this filter in Wireshark:
```
http.request.uri contains "server" or http.request.uri contains "api" or http.request.uri contains "dune"
```

This will show HTTP requests with those keywords in the URL.

