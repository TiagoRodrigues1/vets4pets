package routes

import (
	"projetoapi/controllers"
	"github.com/gin-gonic/gin"
)

func AddPrescription(c *gin.Context) {
	controllers.AddPrescription(c)
}

func DeletePrescription(c *gin.Context) {
	controllers.DeletePrescription(c)
}

func GetPrescriptionsByAnimalID(c *gin.Context) {
	controllers.GetPrescriptionsByAnimalID(c)
}

func GetPrescriptionsByUserID(c *gin.Context) {
	controllers.GetPrescriptionsByUserID(c)
}

