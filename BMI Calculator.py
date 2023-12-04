#!/usr/bin/env python
# coding: utf-8

# In[16]:


name = input("Enter your name: ")

weight = int(input("Enter your weight in kg: "))

height = int(input("Enter your height in cm: "))

BMI = (weight / (height * height)) * 10000

print("Your BMI is: ", BMI)

if BMI > 0:
    if (BMI < 18.5):
        print(name + ", You are underweight.")
        
    elif (BMI <= 24.9):
        print(name + ", You are normalweight.")
        
    elif (BMI <= 29.9):
        print(name + ", You are overweight.")
        
    elif (BMI <= 34.9):
        print(name + ", You are obese.")
        
    elif (BMI < 39.9):
        print(name + ", You are severely obese.")
        
    else:
        print(name + ", You are morbidly obese!")


# In[ ]:




