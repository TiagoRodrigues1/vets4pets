package routes

import (
	"projetoapi/controllers"
	"github.com/gin-gonic/gin"
)

func AddAppointment(c *gin.Context) {
	controllers.AddAppointment(c)
}

func UpdateAppointment(c *gin.Context) {
	controllers.UpdateAppointment(c)
}

func DeleteAppointment(c *gin.Context) {
	controllers.DeleteAppointment(c)
}

func GetAppointmentByVetID (c *gin.Context) {
	controllers.GetAppointmentByVetID(c);
}

func GetAppointmentsOfUser(c *gin.Context) {
    controllers.GetAppointmentsOfUser(c)
}

