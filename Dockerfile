FROM registry.gitlab.com/bjvta/gac-motor/backend:latest

ENV ENVIRONMENT=production

RUN set -eux; \
    gosu app python3 -m venv /python; \
    gosu app /python/bin/pip install -U pip setuptools wheel

COPY --chown=app:app requirements.txt /requirements.txt

RUN set -eux; \
    gosu app pip install --no-cache-dir -r /requirements.txt;

COPY --chown=app:app . /app

RUN set -eux; \
    export DJANGO_SETTINGS_MODULE=gac.settings.build; \
    \
    gosu app pip install --no-cache-dir -e . ; \
    \
    gosu app python \
        src/manage.py collectstatic \
        --noinput \
        --no-color \
        --traceback \
		--verbosity 0 \
        --ignore ".cache" \
        --ignore "node_modules" \
        --ignore "src" \
        --clear

EXPOSE 8000
EXPOSE 8002

CMD ["honcho", "start"]