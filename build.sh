#!/bin/bash
set -e

#
# -- Build Apache Spark Standalone Cluster Docker Images
#

# ----------------------------------------------------------------------------------------------------------------------
# -- Variables
# ----------------------------------------------------------------------------------------------------------------------

BUILD_DATE="$(date -u +'%Y-%m-%d')"

SPARK_VERSION="3.4.1"
SCALA_VERSION="2.12"
HADOOP_VERSION="3"

DELTA_SPARK_VERSION="2.4.0"
DELTALAKE_VERSION="0.10.0"
DELTA_PACKAGE_VERSION="delta-core_2.12:2.4.0"

JUPYTERLAB_VERSION="4.0.2"
PANDAS_VERSION="2.0.1"
SPARK_XML_PACKAGE_VERSION="spark-xml_2.12:0.16.0"
SPARKSQL_MAGIC_VERSION="0.0.3"
KAFKA_PYTHON_VERSION="2.0.2"

VOLUME_NAME="distributed-file-system"

# ----------------------------------------------------------------------------------------------------------------------
# -- Helpers
# ----------------------------------------------------------------------------------------------------------------------

remove_containers_by_name() {
  docker ps -a --filter "name=$1" --format "{{.ID}}" | xargs -r docker rm -f
}

remove_images_by_name() {
  docker images --format "{{.Repository}} {{.ID}}" | grep "$1" | awk '{print $2}' | xargs -r docker rmi -f
}

# ----------------------------------------------------------------------------------------------------------------------
# -- Cleanup
# ----------------------------------------------------------------------------------------------------------------------

cleanContainers() {
  echo "🧹 Cleaning containers..."
  remove_containers_by_name jupyterlab
  remove_containers_by_name spark-worker
  remove_containers_by_name spark-master
  remove_containers_by_name spark-base
  remove_containers_by_name spark-delta-os-base
}

cleanImages() {
  echo "🧹 Cleaning images..."
  remove_images_by_name jupyterlab
  remove_images_by_name spark-worker
  remove_images_by_name spark-master
  remove_images_by_name spark-base
  remove_images_by_name spark-delta-os-base
}

cleanVolume() {
  echo "🧹 Cleaning volume..."
  docker volume rm "${VOLUME_NAME}" 2>/dev/null || true
}

# ----------------------------------------------------------------------------------------------------------------------
# -- Build (ORDER MATTERS)
# ----------------------------------------------------------------------------------------------------------------------

buildImages() {

  docker build \
    --build-arg build_date="${BUILD_DATE}" \
    --build-arg scala_version="${SCALA_VERSION}" \
    --build-arg delta_spark_version="${DELTA_SPARK_VERSION}" \
    --build-arg deltalake_version="${DELTALAKE_VERSION}" \
    --build-arg pandas_version="${PANDAS_VERSION}" \
    -f docker/base/Dockerfile \
    -t spark-delta-os-base:latest .

  docker build \
    --build-arg build_date="${BUILD_DATE}" \
    --build-arg scala_version="${SCALA_VERSION}" \
    --build-arg spark_version="${SPARK_VERSION}" \
    --build-arg hadoop_version="${HADOOP_VERSION}" \
    --build-arg delta_package_version="${DELTA_PACKAGE_VERSION}" \
    --build-arg spark_xml_package_version="${SPARK_XML_PACKAGE_VERSION}" \
    -f docker/spark-base/Dockerfile \
    -t spark-base:${SPARK_VERSION} .

  docker build \
    --build-arg build_date="${BUILD_DATE}" \
    --build-arg spark_version="${SPARK_VERSION}" \
    -f docker/spark-master/Dockerfile \
    -t spark-master:${SPARK_VERSION} .

  docker build \
    --build-arg build_date="${BUILD_DATE}" \
    --build-arg spark_version="${SPARK_VERSION}" \
    -f docker/spark-worker/Dockerfile \
    -t spark-worker:${SPARK_VERSION} .

  docker build \
    --build-arg build_date="${BUILD_DATE}" \
    --build-arg scala_version="${SCALA_VERSION}" \
    --build-arg spark_version="${SPARK_VERSION}" \
    --build-arg jupyterlab_version="${JUPYTERLAB_VERSION}" \
    --build-arg sparksql_magic_version="${SPARKSQL_MAGIC_VERSION}" \
    --build-arg kafka_python_version="${KAFKA_PYTHON_VERSION}" \
    -f docker/jupyterlab/Dockerfile \
    -t jupyterlab:${JUPYTERLAB_VERSION}-spark-${SPARK_VERSION} .
}

cleanContainers
cleanImages
cleanVolume
buildImages

echo "✅ Build completed successfully"
