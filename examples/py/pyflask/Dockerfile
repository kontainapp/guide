FROM python:3.8-slim AS build
RUN mkdir -p /opt/scripts/app/

RUN apt-get update
RUN apt-get install -y --no-install-recommends build-essential gcc

RUN python -m venv /opt/venv
# Make sure we use the virtualenv:
ENV PATH="/opt/venv/bin:$PATH"

ADD . /opt/scripts/
RUN pip install -r /opt/scripts/requirements.txt

ADD app/main.py /opt/scripts/app/
RUN find /opt/scripts/


FROM kontainapp/runenv-python as release
COPY --from=build /opt/venv /opt/venv
COPY --from=build /opt/scripts /opt/scripts
ENV PATH="/opt/venv/bin:$PATH"
WORKDIR /opt/scripts

EXPOSE 5000
CMD ["python", "app/main.py"]