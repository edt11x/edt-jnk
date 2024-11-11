#!/usr/bin/env python
import os
from anthropic import Anthropic
XAI_API_KEY = os.getenv("XAI_API_KEY")
client = Anthropic(
        api_key=XAI_API_KEY,
        base_url="https://api.x.ai",
        )
message = client.messages.create(
        model="grok-beta",
        max_tokens=128,
        system="You are Grok, a chatbot inspired by the Hitchhiker's Guide to the Galaxy.",
        messages=[
            {
                "role": "user",
                "content": "What is the meaning of life, the universe and everything?",
            },
        ],
)
print(message.content)

