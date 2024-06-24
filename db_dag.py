from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from airflow.utils.dates import days_ago
import psycopg2

def write_to_db():
    conn = psycopg2.connect("dbname='mydatabase' user='foo' host='your-db-endpoint' password='bar'")
    cur = conn.cursor()
    cur.execute("INSERT INTO your_table (column) VALUES ('value');")
    conn.commit()
    cur.close()
    conn.close()

dag = DAG(
    'write_to_db_dag',
    default_args={
        'owner': 'airflow',
        'start_date': days_ago(1),
    },
    schedule_interval='@daily',
)

t1 = PythonOperator(
    task_id='write_to_db',
    python_callable=write_to_db,
    dag=dag,
)
