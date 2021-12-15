FROM python:3.8-slim AS build
WORKDIR /opt/src/app
 
RUN python -m venv /opt/venv
# Make sure we use the virtualenv:
ENV PATH="/opt/venv/bin:$PATH"
 
ADD . /opt/src/
RUN pip install -r /opt/src/requirements.txt
 
ADD app/main.py /opt/src/app/
#RUN find /opt/src/
 
 
FROM kontainapp/runenv-python as release
COPY --from=build /opt/venv /opt/venv
COPY --from=build /opt/src/app /opt/src/app
ENV PATH="/opt/venv/bin:$PATH"
WORKDIR /opt/src/app
 
EXPOSE 5000
CMD ["python", "main.py"]