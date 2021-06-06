package controllers

import
 (
	_ "fmt"
	"net/http"
	"projetoapi/model"
	"projetoapi/services"
	 "github.com/gin-gonic/gin"
	 
)

func AddAnswer(c *gin.Context) {
    var answer model.Answer
    if err := c.ShouldBindJSON(&answer); err != nil {
        c.JSON(http.StatusBadRequest,gin.H{"status": http.StatusBadRequest,"message": "Error! Check All Fields"})
        return
    }

    var question model.Question
    services.Db.First(&question, answer.QuestionID)        //Verifica se existe a pergunta
    if question.ID == 0 {
        c.JSON(http.StatusNotFound,gin.H{"status": http.StatusNotFound, "message": "Question does not exist!"})
        return
    } 
    
    var user model.Users
    services.Db.First(&user, answer.UserID)                //Verifica se existe o user                                                                    //Verifica qual se o User exist
    if user.ID == 0 {
        c.JSON(http.StatusBadRequest,gin.H{"status": http.StatusBadRequest,"message": "Error! User does not exist"})
        return
    }

    user.NumberOfAnsweredQuestions++                //Atualiza n de perguntas respondidas
    question.Answers++
    services.Db.Save(&user)                            //Guarda o user
    services.Db.Save(&question)
    services.Db.Save(&answer)                        //Guarda a nova pergunta
    c.JSON(http.StatusCreated, gin.H{"status":http.StatusCreated,"message":"Created Successfully","resourceId" : answer.ID})
}

func DeleteAnswer(c *gin.Context) {
    var answer model.Answer
    var question model.Question
    id := c.Param("id")
    services.Db.First(&answer, id)
    if answer.ID == 0 {
        c.JSON(http.StatusNotFound, gin.H{"status": http.StatusNotFound, "message": "Answer not found!"})
        return
    } 
    services.Db.First(&question, answer.QuestionID)
    question.Answers--
    services.Db.Save(&question)
    services.Db.Delete(&answer)
    c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "message": "Delete succeded!"})
}

func GetAnswers(c *gin.Context) {
	var question model.Question
	var answers []model.Answer
	id := c.Param("id")
	services.Db.First(&question, id)
	if question.ID == 0 {
		c.JSON(http.StatusNotFound, gin.H{"status": http.StatusNotFound, "message": "Question not found!"})
		return
	}
	services.Db.Where("question_id = ?", question.ID).Find(&answers)	
	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "data": answers})
}

func GetAnswersOfUser(c *gin.Context) {
	var user model.Users
	var answers []model.Answer
	id := c.Param("id")
	services.Db.First(&user, id)
	if user.ID == 0 {
		c.JSON(http.StatusNotFound, gin.H{"status": http.StatusNotFound, "message": "User not found!"})
		return
	}
	services.Db.Where("user_id = ?", user.ID).Find(&answers)	
	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "data": answers})
}