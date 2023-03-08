FROM python:3.11

LABEL maintainer="Mário Victor Ribeiro Silva <mariovictorrs@gmail.com>"
LABEL description="Container for feedverse"

ENV TZ America/Sao_Paulo
RUN apt-get clean -y
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get autoremove -y

# Poetry
ENV PYTHONUNBUFFERED=1
ENV PIP_NO_CACHE_DIR=off
ENV PIP_DISABLE_PIP_VERSION_CHECK=on
ENV PIP_DEFAULT_TIMEOUT=100
ENV POETRY_HOME="/opt/poetry"
ENV POETRY_VIRTUALENVS_IN_PROJECT=true
ENV POETRY_NO_INTERACTION=1
ENV PYTHON_SETUP_PATH="/opt/python_setup"
ENV VENV_PATH="/opt/python_setup/.venv"
ENV PATH="$POETRY_HOME/bin:$VENV_PATH/bin:$PATH"
ENV PYTHONPATH="/app"


RUN apt-get install --no-install-recommends -y build-essential curl
RUN curl -sSL https://install.python-poetry.org | python
RUN poetry --version
RUN poetry config virtualenvs.create false

WORKDIR $PYTHON_SETUP_PATH
COPY ./poetry.lock ./pyproject.toml ./
RUN poetry install

WORKDIR  /app

COPY ./ ./

WORKDIR /app

RUN cat ./scripts/web-prestart.sh > /prestart.sh
RUN cat ./scripts/web-start-reload.sh > /start-reload.sh
RUN cat ./scripts/production-web-start.sh > /web-start.sh
RUN cat ./pandora/gunicorn_conf.py > /gunicorn_conf.py

CMD ["bash", "/web-start.sh"]
