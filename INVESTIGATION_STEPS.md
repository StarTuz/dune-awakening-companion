# Steps to Investigate dunestatus.com API

## ⚠️ Better Approach: Find the Game's API Directly

**Before investigating dunestatus.com**, consider finding the game's API directly:
- The game client must call a Funcom API when opening the server browser
- This would be more reliable than using dunestatus.com
- See `FIND_GAME_API.md` and `DATA_SOURCE_STRATEGY.md` for details

---

## Steps to Investigate dunestatus.com API

## Quick Start Guide

### 1. Open Browser DevTools
1. Go to https://dunestatus.com
2. Press **F12** (or Right-click → Inspect)
3. Click the **Network** tab
4. Check **"Preserve log"** checkbox (important!)

### 2. Filter Network Requests
1. In Network tab, click the filter dropdown
2. Select **"XHR"** or **"Fetch"** (these are API calls)
3. Alternatively, type "json" in the filter box

### 3. Interact with the Page
1. **Select a Region** (e.g., "North America")
   - Watch for new network requests
   - Look for requests that return JSON
   
2. **Select a Provider** (e.g., "Funcom")
   - Watch for more network requests
   - Note the pattern

3. **Observe the requests**:
   - What URLs are called?
   - What data is sent?
   - What data is returned?

### 4. Inspect a Request
1. Click on a network request in the list
2. Look at:
   - **Headers** tab: Request URL, Method, Headers
   - **Payload** tab: Any data sent
   - **Response** tab: The JSON/data returned
   - **Preview** tab: Formatted view of response

### 5. Copy Request Details
For each relevant request, note:
- **URL**: The full endpoint
- **Method**: GET, POST, etc.
- **Headers**: Any special headers
- **Response**: The JSON structure

## What to Look For

### Common Patterns

#### Pattern A: REST API
```
Request: GET https://dunestatus.com/api/regions
Response: [{ "id": "na", "name": "North America" }]

Request: GET https://dunestatus.com/api/regions/na/providers  
Response: [{ "id": "funcom", "name": "Funcom" }]

Request: GET https://dunestatus.com/api/providers/funcom/servers
Response: [{ "id": "was", "name": "Was" }]
```

#### Pattern B: Single Endpoint
```
Request: GET https://dunestatus.com/api/servers
Response: {
  "regions": [
    {
      "id": "na",
      "name": "North America",
      "providers": [
        {
          "id": "funcom",
          "name": "Funcom",
          "servers": [
            { "id": "was", "name": "Was" }
          ]
        }
      ]
    }
  ]
}
```

#### Pattern C: GraphQL
```
Request: POST https://dunestatus.com/graphql
Body: {
  "query": "{ regions { id name providers { id name servers { id name } } } }"
}
Response: { "data": { "regions": [...] } }
```

#### Pattern D: Embedded Data
- Check page source (Ctrl+U)
- Look for `<script>` tags with JSON
- Look for `window.__DATA__` or similar variables

## Testing Endpoints

Once you find an endpoint, test it:

### Using Browser Console
```javascript
// In browser console (F12 → Console tab)
fetch('https://dunestatus.com/api/regions')
  .then(r => r.json())
  .then(data => console.log(data));
```

### Using curl (Terminal)
```bash
curl -X GET "https://dunestatus.com/api/regions" \
  -H "Accept: application/json" \
  -H "User-Agent: Mozilla/5.0..."
```

### Using Postman
1. Create new request
2. Set method (GET/POST)
3. Enter URL
4. Add headers
5. Send request
6. View response

## Expected Data Structure

Based on the UI, we need:

```json
{
  "regions": [
    {
      "id": "na",
      "name": "North America"
    },
    {
      "id": "eu", 
      "name": "Europe"
    }
  ],
  "providers": [
    {
      "id": "funcom",
      "name": "Funcom",
      "regionId": "na"
    }
  ],
  "servers": [
    {
      "id": "was",
      "name": "Was",
      "providerId": "funcom"
    }
  ]
}
```

## Share Your Findings

Once you've investigated, share:
1. **Base URL**: e.g., `https://dunestatus.com`
2. **Endpoints**: e.g., `/api/regions`, `/api/servers`
3. **Request Method**: GET, POST, etc.
4. **Headers Required**: Any special headers
5. **Response Format**: Sample JSON response
6. **Authentication**: Any API keys or tokens needed

Then I can update the `DuneStatusApiService` with the actual implementation!

## Alternative: Check Page Source

1. Right-click on dunestatus.com → View Page Source
2. Search for "regions" or "servers" (Ctrl+F)
3. Look for JSON data embedded in JavaScript
4. Might find something like:
   ```javascript
   const serverData = {
     regions: [...],
     providers: [...],
     servers: [...]
   };
   ```

## Screenshot What You Find

Take screenshots of:
- Network tab showing the requests
- Response tab showing the JSON
- Headers tab showing the request details

This will help me understand the exact API structure!

