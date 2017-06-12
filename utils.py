import psycopg2


HOSTNAME = 'localhost'
USERNAME = ''
PASSWORD = ''
DATABASE = ''


def make_query(params):
    '''
    Prepare and make query parameters to be used in connection
    Accepts as input a dict; params
    Returns a string of the SQL query to be executed
    '''
    return select_query(params)


def select_query(params):
    '''
    For queries which are to be executed with a SELECT statement
    Return the SELECT query string with parameters already inserted
    '''
    input_query = ''
    # get called variables
    columns = ''
    try:
        columns = params.get('columns')
        columns = get_columns(columns)
    except KeyError:
        # TODO
        pass
    # get arguments from list
    for i in range(len(params['xparams'])):
        input_query += params['xparams'][i] + ','

    # add select statement doesnt need columns from
    if params['faction'] == 'add':
        mid = ''
        end = '1,2'
    else:
        mid = columns + " FROM "
        end = '1,'+params['pageoffset']+','+params['pagelimit']+','+'2'

    sql = "SELECT " + mid + params['schema'] + ".sp_" + \
        params['tname'] + "_" + params['faction'] + \
        "(" + input_query + end + ")"
    return sql


def execute_query(sql):
    try:
        # open db connection
        conn = open_connection()
        cur = conn.cursor()
        cur.execute(sql)
        rows = cur.fetchall()
        conn.commit()
        close_connection(conn)
        return rows
    except:
        print "could not perform database transactions"


def get_columns(column_list):
    column_string = ''
    if isinstance(column_list, list):
        for i in range(len(column_list)):
            column_string += column_list[i] + ','
            columns = column_string[:-1]
        return columns
    else:
        return column_list


def close_connection(conn):
    '''
    Close existing connection given as input param
    Return None
    '''
    conn.close()


def open_connection():
    '''
    Open new connection
    Return connection object
    '''
    conn = None
    try:
        conn = psycopg2.connect(host=HOSTNAME, user=USERNAME,
                                password=PASSWORD, dbname=DATABASE)
    except:
        print "unable to open", DATABASE
    return conn
