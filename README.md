# lambda-mqtt

Linux:
```bash
sha256sum lambda_function_payload.zip | cut -d ' ' -f 1 | xxd -r -p | base64
```