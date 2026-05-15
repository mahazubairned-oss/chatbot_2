FROM node:20-slim AS frontend-build
WORKDIR /app/frontend
COPY frontend/package.json ./
RUN npm install
COPY frontend/ ./
RUN npm run build

FROM python:3.12-slim
WORKDIR /app

COPY python_code/api/requirements.txt /app/python_code/api/requirements.txt
RUN pip install --no-cache-dir -r /app/python_code/api/requirements.txt

COPY python_code/ /app/python_code/
COPY assets/ /app/assets/
COPY --from=frontend-build /app/frontend/dist /app/frontend/dist

WORKDIR /app/python_code/api
CMD ["sh", "-c", "uvicorn server:app --host 0.0.0.0 --port ${PORT:-8080}"]
