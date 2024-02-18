FROM public.ecr.aws/lambda/python:3.11

WORKDIR ${LAMBDA_TASK_ROOT}

ARG build
RUN test -n "${build}"

COPY main.py .
RUN echo "${build}" > build.txt

CMD [ "main.handler" ]
