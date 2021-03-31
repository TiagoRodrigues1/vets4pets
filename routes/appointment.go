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