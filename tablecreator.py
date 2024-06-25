from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator
from datetime import datetime
import psycopg2

# Определение DAG
with DAG(
    'create_table_in_postgres',
    default_args={
        'owner': 'airflow',
        'depends_on_past': False,
        'start_date': datetime(2023, 1, 1),
        'retries': 1,
    },
    schedule_interval='@once',
    catchup=False,
) as dag:

    # Задача для создания таблицы
    create_table_task = PostgresOperator(
        task_id='create_table',
        postgres_conn_id='my_postgres_connection',
        sql="""
        CREATE TABLE IF NOT EXISTS public.my_table (
            id SERIAL PRIMARY KEY,
            column1 VARCHAR(50),
            column2 INT
        );
        """,
    )

    create_table_task
