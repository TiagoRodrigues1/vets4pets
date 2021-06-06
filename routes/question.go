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

func GetQuestionsOfUser(c *gin.Context) {
	controllers.GetQuestionsOfUser(c)
}

func UpdateQuestion(c *gin.Context) {
	controllers.UpdateQuestion(c)
}