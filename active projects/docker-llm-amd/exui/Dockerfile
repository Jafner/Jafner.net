FROM python:3.10-bookworm
RUN apt update && \
    apt install --no-install-recommends -y git vim build-essential python3-dev pip bash curl && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /usr/src/app
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
RUN git clone https://github.com/turboderp/exui
WORKDIR /usr/src/app/exui
EXPOSE 5000
CMD ["python", "-u", "server.py", "--host", "0.0.0.0:5000"]