package controllers

import (
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
	services.Db.Save(&answer)
	c.JSON(http.StatusCreated, gin.H{"status":http.StatusCreated,"message":"Created Successfully","resourceId" : answer.ID})
}