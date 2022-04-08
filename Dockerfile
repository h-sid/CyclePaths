# For more information, please refer to https://aka.ms/vscode-docker-python
FROM python:3.9-slim

EXPOSE 8080

# Keeps Python from g   enerating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Install pip requirements
COPY requirements.txt /usr/src/app
RUN python -m pip install --default-timeout=1000 --no-cache-dir -r requirements.txt
RUN python -m pip install --default-timeout=1000 --no-cache-dir -e .

COPY CyclePaths /usr/src/app

# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-python-configure-containers
RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /usr/src/app
USER appuser

# During debugging, this entry point will be overridden. For more information, please refer to https://aka.ms/vscode-docker-python-debug
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "wsgi:app", "/usr/src/app/wsgi.py", "--reload"]
