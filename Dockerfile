FROM python:3.13.1-slim

RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN groupadd -r gitingest && useradd --no-log-init -r -g gitingest gitingest

COPY --chown=gitingest:gitingest requirements.txt /app/

RUN pip install --no-cache-dir -r requirements.txt

COPY --chown=gitingest:gitingest . /app/

RUN mkdir -p /app/tmp && chown -R gitingest:gitingest /app/tmp

USER gitingest

EXPOSE 8420

ENV PORT=8420

WORKDIR /app/src

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8420"]
