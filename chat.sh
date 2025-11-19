#!/bin/bash
# Simple CLI for Gemini API using curl

GEMINI_API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-2.5-flash"
API_URL="https://generativelanguage.googleapis.com/v1/models/${MODEL}:generateContent?key=${GEMINI_API_KEY}"

if [ -z "$GEMINI_API_KEY" ]; then
    echo "Error: GEMINI_API_KEY is not set. Please set it using 'export GEMINI_API_KEY=\"YOUR_KEY\"'"
    exit 1
fi

echo "🤖 Gemini Shell CLI Initialized. Type 'exit' or 'quit' to end the session."

while true; do
    read -r -p "You: " PROMPT
    
    if [[ "$PROMPT" =~ ^(exit|quit)$ ]]; then
        echo "Ending chat session. Goodbye!"
        break
    fi

    JSON_PAYLOAD=$(cat <<JSON
{
  "contents": [
    {
      "parts": [
        {
          "text": "${PROMPT}"
        }
      ]
    }
  ]
}
JSON
)

    echo -n "Gemini: "
    
    curl -s -X POST -H "Content-Type: application/json" \
        -d "$JSON_PAYLOAD" "$API_URL" | \
        grep -o '"text": "[^"]*' | \
        sed 's/"text": "//' | \
        sed 's/\\n/\n/g' | \
        sed 's/\\"/"/g'

    echo 
done
