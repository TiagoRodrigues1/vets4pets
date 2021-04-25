package routes

import (
	"projetoapi/controllers"
	"github.com/gin-gonic/gin"
)


func AddQuestion(c *gin.Context) {
	controllers.AddQuestion(c)
}

func DeleteQuestion(c *gin.Context) {
	controllers.DeleteQuestion(c)
}

func GetQuestion(c *gin.Context) {
	controllers.GetQuestion(c)
}


func GetQuestionByTime(c *gin.Context) {
	controllers.GetQuestionByTime(c)
}


