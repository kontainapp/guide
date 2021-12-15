FROM python:3.8-slim AS build
COPY hello.py /
RUN chmod +x /hello.py

FROM kontainapp/runenv-python as release
COPY --from=build /hello.py /hello.py
CMD ["/usr/local/bin/python3","/hello.py"]