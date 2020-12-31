con <- dbConnect(RPostgres::Postgres(), dbname = db, host=host_db, port=db_port, user=db_user, password=db_password)  

run = dbGetQuery(con, "select * from run where unit like '70%' order by date asc")

plot(-25,0,type="n",xlim=c(-15,250),ylim=c(0,20), xaxt="n", yaxt="n", bty="n", xlab="", ylab="")
axis(1, at=c(0,50,100,150,200,250))
abline(v=100, lty=2, col="gray")
units = c(7001:7014)
for (unit in units){
  yOffset = unit - 7000
  unitMileages = run$trip_miles[run$unit==as.character(unit)]
  beginning = 0
  end = vector()
  for (i in 1:length(unitMileages)) {
    beginning = append(beginning, sum(unitMileages[1:(i-1)]))
    end = append(end, sum(unitMileages[1:i]))
  }
  beginning = beginning[-2]
  u = unit
  colors = if(u==7005|u==7007|u==7001|u==7002) {rgb(49, 79, 70, max = 255, alpha = 255*(unitMileages/14))} else rgb(60,179,113, max = 255, alpha = 255*(unitMileages/14))
  
  rect(beginning, yOffset-0.5, end, yOffset+0.5, col=colors, border="white")
  text(-15, u-7000, u)
}
