FROM spark-base:3.4.1

ARG build_date

ENV SPARK_MASTER_URL=spark://spark-master:7077
ENV SPARK_WORKER_MEMORY=1g
ENV SPARK_WORKER_CORES=1
ENV SPARK_WORKER_WEBUI_PORT=8081

EXPOSE 8081

CMD ["spark-class", "org.apache.spark.deploy.worker.Worker", "spark://spark-master:7077"]
