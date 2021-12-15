FROM python:3.8 as build
RUN python -m venv /opt/venv
# Make sure we use the virtualenv:
ENV PATH="/opt/venv/bin:$PATH"

WORKDIR /code
COPY ./requirements.txt /code/requirements.txt
RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt
COPY ./app /code/app
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80"]

FROM kontainapp/runenv-python as release
COPY --from=build /opt/venv /opt/venv
COPY --from=build /opt/scripts /opt/scripts



FROM python:3.8-slim AS build
RUN mkdir -p /opt/scripts/app/

RUN python -m venv /opt/venv
# Make sure we use the virtualenv:
ENV PATH="/opt/venv/bin:$PATH"

ADD . /opt/scripts/
RUN pip install -r /opt/scripts/requirements.txt

ADD app/main.py /opt/scripts/app/
RUN find /opt/scripts/