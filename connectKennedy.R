#' Create Connection to Pelagic Database on Baseline3.
#'
#' Create Connection to Pelagic Database on Baseline3.
#' This connection grant permission to select on tables: master, timseries, iccatt2ce, iotccell, wcpfc, iattc.
#' @param dbuser role name for database
#' @param dbpass database password for role `dbuser`
#' @export
connectKennedy = function(dbuser="jeremy", dbpass="Olimonsterman8"){
  require(RPostgreSQL)
  require(DBI)
  	dbname = "kennedylakes"
  	dbhost <- "localhost"
  	dbport <- 5432
  	drv <- dbDriver("PostgreSQL")
  	con <- dbConnect(drv, host=dbhost, port=dbport, dbname=dbname,  user=dbuser, password=dbpass
  	)
}
