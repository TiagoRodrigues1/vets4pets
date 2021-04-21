package routes

import (
	"projetoapi/controllers"
	"github.com/gin-gonic/gin"
)


func AddClinic(c *gin.Context) {
	controllers.AddClinic(c)
}

func DeleteClinic(c *gin.Context) {
	controllers.DeleteClinic(c)
}

func AddVet(c *gin.Context) {
	controllers.AddVet(c)
}

func RemVet(c *gin.Context) {
	controllers.RemVet(c)
}

func GetClinics(c *gin.Context) {
	controllers.GetClinics(c)
}

func GetVetsClinic(c *gin.Context) {
	controllers.GetVetsClinic(c)
}
