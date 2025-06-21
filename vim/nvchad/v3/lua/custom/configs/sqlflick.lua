local M
M = {
  databases = {
    {
      name = "local_postgres",
      type = "postgresql",
      host = "localhost",
      port = 5432,
      database = "test_db",
      username = "test_user",
      password = "test_password",
    },
    {
      name = "local_mysql",
      type = "mysql",
      host = "localhost",
      port = 3306,
      database = "test_db",
      username = "test_user",
      password = "test_password",
    },
    {
      name = "local_redis",
      type = "redis",
      host = "localhost",
      port = 6379,
    },
    {
      name = "local_sqlite",
      type = "sqlite",
      database = "test.db"
    },
  },
}
return M
