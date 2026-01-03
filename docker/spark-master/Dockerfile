FROM spark-base:3.4.1

ARG build_date

ENV SPARK_MASTER_HOST=spark-master
ENV SPARK_MASTER_PORT=7077
ENV SPARK_MASTER_WEBUI_PORT=8080

EXPOSE 7077 8080

CMD ["spark-class", "org.apache.spark.deploy.master.Master"]
