package routes

import (
	"projetoapi/controllers"
	"github.com/gin-gonic/gin"
)


func AddAnswer(c *gin.Context) {
	controllers.AddAnswer(c)
}

func DeleteAnswer(c *gin.Context) {
	controllers.DeleteAnswer(c)
}

func GetAnswers(c *gin.Context) {
	controllers.GetAnswers(c)
}