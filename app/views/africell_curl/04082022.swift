
04/08/2022

Login


curl -H "Content-Type: application/json"  -H "Authorization: Basic UGFnYVNPQWRtaW46MjAyMlBAR0BTMFQzQ2g=" -X GET http://10.250.80.74:9214/HTTP_Login/


Your OTP is : FF08wlQNwDOODA0



02 - Validate OPT



curl -I -H "Content-Type: application/json"  -H "Authorization: Basic UGFnYVNPQWRtaW46MjAyMlBAR0BTMFQzQ2g=" -H "otp: FF08wlQNwDOODA0" -X GET http://10.250.80.74:9214/HTTP_ValidateOTP/


Authorization: Bearer eyJMb2dpbiI6IlBhZ2FTT0FkbWluIiwiVG9rZW5UeXBlIjoiQWNjZXNzIiwiYWxnIjoiUFM1MTIiLCJ0eXAiOiJKV1MifQ.eyJTb3VyY2VJUCI6IjE3Mi4yNi4xMC42IiwiVXNlckluZm8iOnsiQ2FuQ3JlYXRlQVBJVXNlciI6ZmFsc2UsIkNhbkV4ZWN1dGVCYWxDaGVjayI6dHJ1ZSwiQ2FuRXhlY3V0ZVJlY2hhcmdlIjp0cnVlLCJDYW5FeGVjdXRlU3RhdGVtZW50Ijp0cnVlLCJFbWFpbCI6InJvc2kudm9sZ2FyaW5AdGl2LXRlY25vbG9naWEuY29tIiwiRmlyc3ROYW1lIjoiUGFnYVNPIiwiTGFzdE5hbWUiOiJQYWdhU08iLCJNaWRkbGVOYW1lIjoiIiwiUGhvbmUiOiIiLCJUaGlyZFBhcnR5TmFtZSI6IlBhZ2FTTyJ9LCJhdWQiOlsiQWZyaWNlbGwiLCJQYWdhU08iXSwiZXhwIjoxNjU5NjU4ODgxLCJpYXQiOjE2NTk2NTUyODEsImlzcyI6ImFmcl9hb190Z3ciLCJqdGkiOiI5Iiwic3ViIjoiQWZyaWNlbGwgVEdXIEJlYXJlciB0b2tlbiJ9.IV2y5W1VuwSjGBqUvWyGp89mx1qCVMHhrQECc3cJHF1J6rqPZea5HCq-tgxmDvGUW3ZYhIBcsAn_F0T5vPPPn7EMsponND4pWhExponbboHzJDGxdRHVgMbI0iba0-NvumhFF-BGfLMt7JwyRxdUCnsWsM6UNz4GhD3KNlzHZs0g2z-OfHMlaSk_p0GPLWKvABCEYnjEymoozUKWwN_VXeRVT_aTVAorNlx7GjqYJTTwdsAvOBx5WGIrP6B-fawTcFxYHTe0hgfRIMhrQUZFAlj-nGtEHYTn7TB5m2q6fzjPmUq6ed18POUVmloapOMxK-qmFPpu7hP-3LLm-qmRMw








03 - Get refresh token

curl -I -H "Content-Type: application/json" -H "Authorization: Bearer eyJMb2dpbiI6IlBhZ2FTT0FkbWluIiwiVG9rZW5UeXBlIjoiQWNjZXNzIiwiYWxnIjoiUFM1MTIiLCJ0eXAiOiJKV1MifQ.eyJTb3VyY2VJUCI6IjE3Mi4yNi4xMC42IiwiVXNlckluZm8iOnsiQ2FuQ3JlYXRlQVBJVXNlciI6ZmFsc2UsIkNhbkV4ZWN1dGVCYWxDaGVjayI6dHJ1ZSwiQ2FuRXhlY3V0ZVJlY2hhcmdlIjp0cnVlLCJDYW5FeGVjdXRlU3RhdGVtZW50Ijp0cnVlLCJFbWFpbCI6InJvc2kudm9sZ2FyaW5AdGl2LXRlY25vbG9naWEuY29tIiwiRmlyc3ROYW1lIjoiUGFnYVNPIiwiTGFzdE5hbWUiOiJQYWdhU08iLCJNaWRkbGVOYW1lIjoiIiwiUGhvbmUiOiIiLCJUaGlyZFBhcnR5TmFtZSI6IlBhZ2FTTyJ9LCJhdWQiOlsiQWZyaWNlbGwiLCJQYWdhU08iXSwiZXhwIjoxNjU5NjU4ODgxLCJpYXQiOjE2NTk2NTUyODEsImlzcyI6ImFmcl9hb190Z3ciLCJqdGkiOiI5Iiwic3ViIjoiQWZyaWNlbGwgVEdXIEJlYXJlciB0b2tlbiJ9.IV2y5W1VuwSjGBqUvWyGp89mx1qCVMHhrQECc3cJHF1J6rqPZea5HCq-tgxmDvGUW3ZYhIBcsAn_F0T5vPPPn7EMsponND4pWhExponbboHzJDGxdRHVgMbI0iba0-NvumhFF-BGfLMt7JwyRxdUCnsWsM6UNz4GhD3KNlzHZs0g2z-OfHMlaSk_p0GPLWKvABCEYnjEymoozUKWwN_VXeRVT_aTVAorNlx7GjqYJTTwdsAvOBx5WGIrP6B-fawTcFxYHTe0hgfRIMhrQUZFAlj-nGtEHYTn7TB5m2q6fzjPmUq6ed18POUVmloapOMxK-qmFPpu7hP-3LLm-qmRMw" -X GET http://10.250.80.74:9214/HTTP_RefreshToken/

Resposta

HTTP/1.1 200 OK
Authorization: Bearer eyJMb2dpbiI6IlBhZ2FTT0FkbWluIiwiVG9rZW5UeXBlIjoiUmVmcmVzaCIsImFsZyI6IlBTNTEyIiwidHlwIjoiSldTIn0.eyJTb3VyY2VJUCI6IjE3Mi4yNi4xMC42IiwiVXNlckluZm8iOnsiQ2FuQ3JlYXRlQVBJVXNlciI6ZmFsc2UsIkNhbkV4ZWN1dGVCYWxDaGVjayI6dHJ1ZSwiQ2FuRXhlY3V0ZVJlY2hhcmdlIjp0cnVlLCJDYW5FeGVjdXRlU3RhdGVtZW50Ijp0cnVlLCJFbWFpbCI6InJvc2kudm9sZ2FyaW5AdGl2LXRlY25vbG9naWEuY29tIiwiRmlyc3ROYW1lIjoiUGFnYVNPIiwiTGFzdE5hbWUiOiJQYWdhU08iLCJNaWRkbGVOYW1lIjoiIiwiUGhvbmUiOiIiLCJUaGlyZFBhcnR5TmFtZSI6IlBhZ2FTTyJ9LCJhdWQiOlsiQWZyaWNlbGwiLCJQYWdhU08iXSwiZXhwIjoxNjYwMjYwMzI3LCJpYXQiOjE2NTk2NTU1MjcsImlzcyI6ImFmcl9hb190Z3ciLCJqdGkiOiIyIiwic3ViIjoiQWZyaWNlbGwgVEdXIEJlYXJlciB0b2tlbiJ9.fyqqxPze19Uiu3X_y0HRNNkPss4DyKVbtNUuYi2x18CRdUwMc5jmlhLvjSFa0qiYYX3L_qZKSgozllJj8tW9epUtB6wHVv-2mStf7o3InV5H42nNlbG8N-v5UyukFEpXobp9WJG3P7zEyaxjZQ3WF4QYlm10C9QFV6fmHuqX5YSQeuIvwVQ67zLSy6Xrn3CTqLto9uABYmtO75GXqKjwuwnkHJgPWVnviGNI3V_dYhbvPN0bWKxYqyVn52AUcvS1jNigNkXIziCTJ1Gvhoo5bU0lxF8Mj4AehTTfAIcg8632VOCYqH074y_5xiPuZR2IZKpVuIEy7u8IjE0xIM8DQQ
Content-Type: application/json
Date: Thu, 04 Aug 2022 23:25:27 GMT
Content-Length: 46





04 - Dealer Balance Check

curl -X GET http://10.250.80.74:9214/HTTP_CheckDealerBalance/ -H "Content-Type: application/json" -H "Authorization: Bearer eyJMb2dpbiI6IlBhZ2FTT0FkbWluIiwiVG9rZW5UeXBlIjoiUmVmcmVzaCIsImFsZyI6IlBTNTEyIiwidHlwIjoiSldTIn0.eyJTb3VyY2VJUCI6IjE3Mi4yNi4xMC42IiwiVXNlckluZm8iOnsiQ2FuQ3JlYXRlQVBJVXNlciI6ZmFsc2UsIkNhbkV4ZWN1dGVCYWxDaGVjayI6dHJ1ZSwiQ2FuRXhlY3V0ZVJlY2hhcmdlIjp0cnVlLCJDYW5FeGVjdXRlU3RhdGVtZW50Ijp0cnVlLCJFbWFpbCI6InJvc2kudm9sZ2FyaW5AdGl2LXRlY25vbG9naWEuY29tIiwiRmlyc3ROYW1lIjoiUGFnYVNPIiwiTGFzdE5hbWUiOiJQYWdhU08iLCJNaWRkbGVOYW1lIjoiIiwiUGhvbmUiOiIiLCJUaGlyZFBhcnR5TmFtZSI6IlBhZ2FTTyJ9LCJhdWQiOlsiQWZyaWNlbGwiLCJQYWdhU08iXSwiZXhwIjoxNjYwMjYwMzI3LCJpYXQiOjE2NTk2NTU1MjcsImlzcyI6ImFmcl9hb190Z3ciLCJqdGkiOiIyIiwic3ViIjoiQWZyaWNlbGwgVEdXIEJlYXJlciB0b2tlbiJ9.fyqqxPze19Uiu3X_y0HRNNkPss4DyKVbtNUuYi2x18CRdUwMc5jmlhLvjSFa0qiYYX3L_qZKSgozllJj8tW9epUtB6wHVv-2mStf7o3InV5H42nNlbG8N-v5UyukFEpXobp9WJG3P7zEyaxjZQ3WF4QYlm10C9QFV6fmHuqX5YSQeuIvwVQ67zLSy6Xrn3CTqLto9uABYmtO75GXqKjwuwnkHJgPWVnviGNI3V_dYhbvPN0bWKxYqyVn52AUcvS1jNigNkXIziCTJ1Gvhoo5bU0lxF8Mj4AehTTfAIcg8632VOCYqH074y_5xiPuZR2IZKpVuIEy7u8IjE0xIM8DQQ"

Resposta à consulta

└─(00:25:27)──> curl -X GET http://10.250.80.74:9214/HTTP_CheckDealerBalance/ -H "Content-Type: application/json" -H "Authorization: Bearer eyJMb2dpbiI6IlBhZ2FTT0FkbWluIiwiVG9rZW5UeXBlIjoiUmVmcmVzaCIsImFsZyI6IlBTNTEyIiwidHlwIjoiSldTIn0.eyJTb3VyY2VJUCI6IjE3Mi4yNi4xMC42IiwiVXNlckluZm8iOnsiQ2FuQ3JlYXRlQVBJVXNlciI6ZmFsc2UsIkNhbkV4ZWN1dGVCYWxDaGVjayI6dHJ1ZSwiQ2FuRXhlY3V0ZVJlY2hhcmdlIjp0cnVlLCJDYW5FeGVjdXRlU3RhdGVtZW50Ijp0cnVlLCJFbWFpbCI6InJvc2kudm9sZ2FyaW5AdGl2LXRlY25vbG9naWEuY29tIiwiRmlyc3ROYW1lIjoiUGFnYVNPIiwiTGFzdE5hbWUiOiJQYWdhU08iLCJNaWRkbGVOYW1lIjoiIiwiUGhvbmUiOiIiLCJUaGlyZFBhcnR5TmFtZSI6IlBhZ2FTTyJ9LCJhdWQiOlsiQWZyaWNlbGwiLCJQYWdhU08iXSwiZXhwIjoxNjYwMjYwMzI3LCJpYXQiOjE2NTk2NTU1MjcsImlzcyI6ImFmcl9hb190Z3ciLCJqdGkiOiIyIiwic3ViIjoiQWZyaWNlbGwgVEdXIEJlYXJlciB0b2tlbiJ9.fyqqxPze19Uiu3X_y0HRNNkPss4DyKVbtNUuYi2x18CRdUwMc5jmlhLvjSFa0qiYYX3L_qZKSgozllJj8tW9epUtB6wHVv-2mStf7o3InV5H42nNlbG8N-v5UyukFEpXobp9WJG3P7zEyaxjZQ3WF4QYlm10C9QFV6fmHuqX5YSQeuIvwVQ67zLSy6Xrn3CTqLto9uABYmtO75GXqKjwuwnkHJgPWVnviGNI3V_dYhbvPN0bWKxYqyVn52AUcvS1jNigNkXIziCTJ1Gvhoo5bU0lxF8Mj4AehTTfAIcg8632VOCYqH074y_5xiPuZR2IZKpVuIEy7u8IjE0xIM8DQQ"
{"type":"INVALID_REQUEST","errors":[{"code":400,"message":"Bad Request: error in get account balance:BRM Error -Invalid account number"}]}



05 - Recarga

curl -X POST http://10.250.80.74:9214/HTTP_Recharge/ -H "Content-Type: application/json" -H "Authorization: Bearer eyJMb2dpbiI6IlBhZ2FTT0FkbWluIiwiVG9rZW5UeXBlIjoiUmVmcmVzaCIsImFsZyI6IlBTNTEyIiwidHlwIjoiSldTIn0.eyJTb3VyY2VJUCI6IjE3Mi4yNi4xMC42IiwiVXNlckluZm8iOnsiQ2FuQ3JlYXRlQVBJVXNlciI6ZmFsc2UsIkNhbkV4ZWN1dGVCYWxDaGVjayI6dHJ1ZSwiQ2FuRXhlY3V0ZVJlY2hhcmdlIjp0cnVlLCJDYW5FeGVjdXRlU3RhdGVtZW50Ijp0cnVlLCJFbWFpbCI6InJvc2kudm9sZ2FyaW5AdGl2LXRlY25vbG9naWEuY29tIiwiRmlyc3ROYW1lIjoiUGFnYVNPIiwiTGFzdE5hbWUiOiJQYWdhU08iLCJNaWRkbGVOYW1lIjoiIiwiUGhvbmUiOiIiLCJUaGlyZFBhcnR5TmFtZSI6IlBhZ2FTTyJ9LCJhdWQiOlsiQWZyaWNlbGwiLCJQYWdhU08iXSwiZXhwIjoxNjYwNjU0OTI4LCJpYXQiOjE2NjAwNTAxMjgsImlzcyI6ImFmcl9hb190Z3ciLCJqdGkiOiIyNyIsInN1YiI6IkFmcmljZWxsIFRHVyBCZWFyZXIgdG9rZW4ifQ.NuZfLeJPgJkJVR8Fa3s4vwyrzWPKRo6nDZs7jrqXiH1hVeiVWs4qHrtO6yjKSoHiVFTzBgkXJalxg9CC60rB4ngFO0f-hXrGD9aMcyWGNTVl8992154J4B8-ZB5BuUOBJqxx61ppMaUdQnLZHdQ40-lqk2-uu1ItxZzheJeKPhGP38ubMo8notsyE0ISwPZ2VSnTFlPkcOJ0HcLvA3meUPTDyvT-nxPk6f6kvZybW5zvxUaXUfmPbFecJiWjyBywnnzPCcKTQew9adG3HozgQyOyRXcwxzBkmJ_VDdZkvXbDntiz5XUtsWbQDCSTNgO-eXDymxvPkKsmOjYcw8flZQ" -d '{"ProductCode":"01", "ParameterCode":"01", "Amount":"", "TargetMSISDN":"244959560801", "TransactionReference":"1"}'

=================

curl -I -d '{"ProductCode":"01","ParameterCode":"01","Amount":"","TargetMSISDN":"244959560801","TransactionReference":"1"}'  -H "Content-Type: application/json" -H "Authorization: Bearer eyJMb2dpbiI6IlBhZ2FTT0FkbWluIiwiVG9rZW5UeXBlIjoiUmVmcmVzaCIsImFsZyI6IlBTNTEyIiwidHlwIjoiSldTIn0.eyJTb3VyY2VJUCI6IjE3Mi4yNi4xMC42IiwiVXNlckluZm8iOnsiQ2FuQ3JlYXRlQVBJVXNlciI6ZmFsc2UsIkNhbkV4ZWN1dGVCYWxDaGVjayI6dHJ1ZSwiQ2FuRXhlY3V0ZVJlY2hhcmdlIjp0cnVlLCJDYW5FeGVjdXRlU3RhdGVtZW50Ijp0cnVlLCJFbWFpbCI6InJvc2kudm9sZ2FyaW5AdGl2LXRlY25vbG9naWEuY29tIiwiRmlyc3ROYW1lIjoiUGFnYVNPIiwiTGFzdE5hbWUiOiJQYWdhU08iLCJNaWRkbGVOYW1lIjoiIiwiUGhvbmUiOiIiLCJUaGlyZFBhcnR5TmFtZSI6IlBhZ2FTTyJ9LCJhdWQiOlsiQWZyaWNlbGwiLCJQYWdhU08iXSwiZXhwIjoxNjYwNjU0OTI4LCJpYXQiOjE2NjAwNTAxMjgsImlzcyI6ImFmcl9hb190Z3ciLCJqdGkiOiIyNyIsInN1YiI6IkFmcmljZWxsIFRHVyBCZWFyZXIgdG9rZW4ifQ.NuZfLeJPgJkJVR8Fa3s4vwyrzWPKRo6nDZs7jrqXiH1hVeiVWs4qHrtO6yjKSoHiVFTzBgkXJalxg9CC60rB4ngFO0f-hXrGD9aMcyWGNTVl8992154J4B8-ZB5BuUOBJqxx61ppMaUdQnLZHdQ40-lqk2-uu1ItxZzheJeKPhGP38ubMo8notsyE0ISwPZ2VSnTFlPkcOJ0HcLvA3meUPTDyvT-nxPk6f6kvZybW5zvxUaXUfmPbFecJiWjyBywnnzPCcKTQew9adG3HozgQyOyRXcwxzBkmJ_VDdZkvXbDntiz5XUtsWbQDCSTNgO-eXDymxvPkKsmOjYcw8flZQ" -X POST http://10.250.80.74:9214//HTTP_Recharge/ -v

========================


{"ProductCode":"01","ParameterCode":"01","Amount":200.0,"TargetMSISDN":"244959560801","TransactionReference":"4"}


{"Content-Type"=>"application/json", "Authorization"=>"Basic UGFnYVNPQWRtaW46MjAyMlBAR0BTMFQzQ2g=", "otp"=>"w7kJg469K9lASZu"}
{"Content-Type"=>"application/json", "Authorization"=>"Bearer eyJMb2dpbiI6IlBhZ2FTT0FkbWluIiwiVG9rZW5UeXBlIjoiQWNjZXNzIiwiYWxnIjoiUFM1MTIiLCJ0eXAiOiJKV1MifQ.eyJTb3VyY2VJUCI6IjE3Mi4yNi4xMC42IiwiVXNlckluZm8iOnsiQ2FuQ3JlYXRlQVBJVXNlciI6ZmFsc2UsIkNhbkV4ZWN1dGVCYWxDaGVjayI6dHJ1ZSwiQ2FuRXhlY3V0ZVJlY2hhcmdlIjp0cnVlLCJDYW5FeGVjdXRlU3RhdGVtZW50Ijp0cnVlLCJFbWFpbCI6InJvc2kudm9sZ2FyaW5AdGl2LXRlY25vbG9naWEuY29tIiwiRmlyc3ROYW1lIjoiUGFnYVNPIiwiTGFzdE5hbWUiOiJQYWdhU08iLCJNaWRkbGVOYW1lIjoiIiwiUGhvbmUiOiIiLCJUaGlyZFBhcnR5TmFtZSI6IlBhZ2FTTyJ9LCJhdWQiOlsiQWZyaWNlbGwiLCJQYWdhU08iXSwiZXhwIjoxNjU5OTY1NDQzLCJpYXQiOjE2NTk5NjE4NDMsImlzcyI6ImFmcl9hb190Z3ciLCJqdGkiOiIyMiIsInN1YiI6IkFmcmljZWxsIFRHVyBCZWFyZXIgdG9rZW4ifQ.JFbJRdSh0_IauzlfjEZA-S6Tz0efAACX8GgxC1fud7LnqcwSCDgZ_sjkOPRExeR8MZi1Y4bu0tMUvYznkMly70Tty0g5_NpCPXconttYhH6-XsU7XU4rpEYIhUVhwLMBsxqkP8qTkOohIIH-xyhFFnXIal89lW02MluczYfBTv7d4907MOiB4C8bys1-2Y_5Gh4XNkSkBwXS_O-9C_psrmwzRzeMWZYOMBE6Ws2sT8ktgJMZbTl0YOmSop2Qp_DB6jqcDhrzqSt8Bm0p5Ga5-_MVD_Z1Z7zM34G_g-8-EGyGEShTKQ-eMGdBhwyEJHMbatLIUdFxfJsGFLy8vSfWqQ"}
==========================================
#<HTTParty::Response:0x46960 parsed_response={"Receive_Date"=>"2022-08-08T12:30:43.581999002Z", "Login"=>"PagaSOAdmin", "ThirdPartyName"=>"PagaSO", "DealerMSISDN"=>"244950170237", "DealerBalance"=>-10000, "Status"=>"Successful", "StatusCode"=>200, "StatusDescription"=>"OK", "StatusDate"=>"2022-08-08T12:30:43.672477576Z", "Elapsedtime"=>90}, @response=#<Net::HTTPOK 200 OK readbody=true>, @headers={"content-type"=>["application/json"], "date"=>["Mon, 08 Aug 2022 12:30:43 GMT"], "content-length"=>["278"], "connection"=>["close"]}>
==========================================
{"Receive_Date":"2022-08-08T12:30:43.581999002Z","Login":"PagaSOAdmin","ThirdPartyName":"PagaSO","DealerMSISDN":"244950170237","DealerBalance":-10000,"Status":"Successful","StatusCode":200,"StatusDescription":"OK","StatusDate":"2022-08-08T12:30:43.672477576Z","Elapsedtime":90}






Exemplo de venda válida

└─(14:08:02 on master ✹)──> curl -X POST http://10.250.80.74:9214/HTTP_Recharge/ -H "Content-Type: application/json" -H "Authorization: Bearer eyJMb2dpbiI6IlBhZ2FTT0FkbWluIiwiVG9rZW5UeXBlIjoiUmVmcmVzaCIsImFsZyI6IlBTNTEyIiwidHlwIjoiSldTIn0.eyJTb3VyY2VJUCI6IjE3Mi4yNi4xMC42IiwiVXNlckluZm8iOnsiQ2FuQ3JlYXRlQVBJVXNlciI6ZmFsc2UsIkNhbkV4ZWN1dGVCYWxDaGVjayI6dHJ1ZSwiQ2FuRXhlY3V0ZVJlY2hhcmdlIjp0cnVlLCJDYW5FeGVjdXRlU3RhdGVtZW50Ijp0cnVlLCJFbWFpbCI6InJvc2kudm9sZ2FyaW5AdGl2LXRlY25vbG9naWEuY29tIiwiRmlyc3ROYW1lIjoiUGFnYVNPIiwiTGFzdE5hbWUiOiJQYWdhU08iLCJNaWRkbGVOYW1lIjoiIiwiUGhvbmUiOiIiLCJUaGlyZFBhcnR5TmFtZSI6IlBhZ2FTTyJ9LCJhdWQiOlsiQWZyaWNlbGwiLCJQYWdhU08iXSwiZXhwIjoxNjYwNjU0OTI4LCJpYXQiOjE2NjAwNTAxMjgsImlzcyI6ImFmcl9hb190Z3ciLCJqdGkiOiIyNyIsInN1YiI6IkFmcmljZWxsIFRHVyBCZWFyZXIgdG9rZW4ifQ.NuZfLeJPgJkJVR8Fa3s4vwyrzWPKRo6nDZs7jrqXiH1hVeiVWs4qHrtO6yjKSoHiVFTzBgkXJalxg9CC60rB4ngFO0f-hXrGD9aMcyWGNTVl8992154J4B8-ZB5BuUOBJqxx61ppMaUdQnLZHdQ40-lqk2-uu1ItxZzheJeKPhGP38ubMo8notsyE0ISwPZ2VSnTFlPkcOJ0HcLvA3meUPTDyvT-nxPk6f6kvZybW5zvxUaXUfmPbFecJiWjyBywnnzPCcKTQew9adG3HozgQyOyRXcwxzBkmJ_VDdZkvXbDntiz5XUtsWbQDCSTNgO-eXDymxvPkKsmOjYcw8flZQ" -d '{"ProductCode":"01", "ParameterCode":"01", "Amount":"", "TargetMSISDN":"244959560801", "TransactionReference":"1"}'

{"TransactionId":"220809131051085391","ReceiveDate":"2022-08-09T13:10:51.361863155Z","SourceIP":"172.26.10.6","Login":"PagaSOAdmin","ThirdPartyName":"PagaSO","DealerMSISDN":"244950170237","ProductCode":"01","ParameterCode":"01","ProductType":"Airtime","ProductPrice":200,"ProductDescription":"200 Kz","TargetMSISDN":"244959560801","TransactionReference":"1","CS_PackageId":"","CS_Start_time":"2022-08-09T13:10:51.362150121Z","CS_End_time":"2022-08-09T13:10:51.582437249Z","CS_Elapsed_time":220,"CS_Status":"Successful","CS_Response":{"response":{"success":"true",

"result":{"arguments":
    {"AFRICELL_FLD_DESTINATION_ACCOUNT":
        {"AMOUNT":"200","BALANCE_GROUPS":
            [{"BALANCES":
                [
                    {"AMOUNT_ORIG":"-1048576000",
                    "CREDIT_FLOOR":"-9223372036854776000",
                    "CREDIT_LIMIT":"0",
                    "CURRENT_BAL":"-1048576000",
                    "DESCR":"Bonus_Data_Bank",
                    "END_T":"1660518000",
                    "INFO":"Currency Balance Bank",
                    "RESOURCE_ID":"7010004",
                    "START_T":"1659567600",
                    "TYPE_STR":"Byte",
                    "elem":"7010004"},
                {"AMOUNT_ORIG":"-211885",
                    "CREDIT_FLOOR":"-9223372036854776000",
                    "CREDIT_LIMIT":"0",
                    "CURRENT_BAL":"-40177",
                    "DESCR":"Onnet_Voice_Bank",
                    "END_T":"1660639060",
                    "INFO":"Daily Voice Combo",
                    "RESOURCE_ID":"8010001",
                    "START_T":"1649199600",
                    "TYPE_STR":"Second",
                    "elem":"8010001"},
                {"AMOUNT_ORIG":"-211885",
                    "CREDIT_FLOOR":"-9223372036854776000",
                    "CREDIT_LIMIT":"9223372036854776000",
                    "CURRENT_BAL":"-447",
                    "DESCR":"Onnet_Voice_Tracker",
                    "END_T":"0",
                    "INFO":"Currency Balance Bank",
                    "RESOURCE_ID":"5010002",
                    "START_T":"1648916208",
                    "TYPE_STR":"None",
                    "elem":"5010002"},
                {"AMOUNT_ORIG":"0",
                    "CREDIT_FLOOR":"-9223372036854776000",
                    "CREDIT_LIMIT":"0",
                    "CURRENT_BAL":"0",
                    "DESCR":"AOA",
                    "END_T":"0",
                    "INFO":"Currency Balance Bank",
                    "RESOURCE_ID":"973",
                    "START_T":"1648854000",
                    "TYPE_STR":"None",
                    "elem":"973"},
                {"AMOUNT_ORIG":"0",
                    "CREDIT_FLOOR":"-9223372036854776000",
                    "CREDIT_LIMIT":"0",
                    "CURRENT_BAL":"-350.88",
                    "DESCR":"Recharge_Balance_Bank",
                    "END_T":"0",
                    "INFO":"Currency Balance Bank",
                    "RESOURCE_ID":"6010001",
                    "START_T":"1648854000",
                    "TYPE_STR":"None",
                    "elem":"6010001"},
                {"AMOUNT_ORIG":"-83886080",
                    "CREDIT_FLOOR":"-84934656",
                    "CREDIT_LIMIT":"0",
                    "CURRENT_BAL":"-42991616",
                    "DESCR":"Facebook_Data_Bank",
                    "END_T":"1660086000",
                    "INFO":"Daily Voice Combo",
                    "RESOURCE_ID":"7010001",
                    "START_T":"1649199600",
                    "TYPE_STR":"Byte",
                    "elem":"7010001"},
                {"AMOUNT_ORIG":"-14400",
                    "CREDIT_FLOOR":"-9223372036854776000",
                    "CREDIT_LIMIT":"0",
                    "CURRENT_BAL":"-14400",
                    "DESCR":"Weekend_Onnet_Voice_Bank",
                    "END_T":"1660259053",
                    "INFO":"Weekend 20",
                    "RESOURCE_ID":"8010010",
                    "START_T":"1659629382",
                    "TYPE_STR":"Second",
                    "elem":"8010010"},
                {"AMOUNT_ORIG":"0",
                    "CREDIT_FLOOR":"-9223372036854776000",
                    "CREDIT_LIMIT":"0",
                    "CURRENT_BAL":"0",
                    "DESCR":"Bonus_Onnet_Voice_Bank",
                    "END_T":"0",
                    "INFO":"Kuyuyu SIM",
                    "RESOURCE_ID":"8010005",
                    "START_T":"1648854000",
                    "TYPE_STR":"Second",
                    "elem":"8010005"},
                {"AMOUNT_ORIG":"-80",
                    "CREDIT_FLOOR":"-3018",
                    "CREDIT_LIMIT":"0",
                    "CURRENT_BAL":"-60",
                    "DESCR":"Sms_Bank",
                    "END_T":"1660086000",
                    "INFO":"Daily Voice Combo",
                    "RESOURCE_ID":"9010001",
                    "START_T":"1649199600",
                    "TYPE_STR":"None",
                    "elem":"9010001"},
                {"AMOUNT_ORIG":"-1048576000",
                    "CREDIT_FLOOR":"-9223372036854776000",
                    "CREDIT_LIMIT":"0",
                    "CURRENT_BAL":"-1048576000",
                    "DESCR":"Weekend_Data_Bank",
                    "END_T":"1660259053",
                    "INFO":"Weekend 20",
                    "RESOURCE_ID":"7010012",
                    "START_T":"1659629382",
                    "TYPE_STR":"Byte",
                    "elem":"7010012"}
                ],
                    "BAL_GRP_OBJ":"0.0.0.1 /balance_group 1432880991 0",
                    "elem":"0"}
                ]},
                    "AFRICELL_FLD_SOURCE_ACCOUNT":
                    {
                        "AMOUNT":"200",
                        "BALANCE_GROUPS":
                            [
                                {"BALANCES":
                                    [
                                        {
                                            "AMOUNT_ORIG":"0",
                                            "CREDIT_FLOOR":"",
                                            "CREDIT_LIMIT":"0",
                                            "CURRENT_BAL":"-9800",
                                            "DESCR":"Recharge_Balance_Bank",
                                            "END_T":"0",
                                            "INFO":"Currency Balance Bank",
                                            "RESOURCE_ID":"6010001",
                                            "START_T":"1659959873",
                                            "TYPE_STR":"None",
                                            "elem":"6010001"
                                        }
                                    ],
                                    "BAL_GRP_OBJ":"0.0.0.1 /balance_group 20550828197 2",
                                    "BILLINFO_OBJ":"0.0.0.1 /billinfo 20550828837 0",
                                    "elem":"0"
                                    }
                                ]
                            },
                            "AMOUNT":"200",
                            "CSMART_FLD_SOURCE_DEALER_CODE":"DLR_UAT15582",
                            "DESCR":"Balance transferred successfully",
                            "DEVICE_ID":"244959560801",
                            "ERROR_NUM":"0",
                            "EVENT_OBJ":"0.0.0.1 /event/billing/debit 337998691519738208 0",
                            "POID":"0.0.0.1 /account 1 0","PROGRAM_NAME":"CSMART BAL TRANSFER","PROVIDER_DESCR":"D2C_DLR_UAT15582_244959560801"},
                                                        "message":"Balance transferred successfully!","success":"true","record":"337998691519738208"}}},"Status":"Successful","StatusCode":200,"StatusDescription":"OK","StatusDate":"2022-08-09T13:10:51.582444031Z","Elapsedtime":220}
┌─(~/PagasoAPP/pgstrans/log)(ruby-2.7.2)───────────────────────────────────────────────────────────────────────────(pgsadmin@pgs-qa-al


7 - Check Transaction Log

Exemplo de transação com sucesso

curl -H "Content-Type: application/json" -H "Authorization: Bearer eyJMb2dpbiI6IlBhZ2FTT0FkbWluIiwiVG9rZW5UeXBlIjoiUmVmcmVzaCIsImFsZyI6IlBTNTEyIiwidHlwIjoiSldTIn0.eyJTb3VyY2VJUCI6IjE3Mi4yNi4xMC42IiwiVXNlckluZm8iOnsiQ2FuQ3JlYXRlQVBJVXNlciI6ZmFsc2UsIkNhbkV4ZWN1dGVCYWxDaGVjayI6dHJ1ZSwiQ2FuRXhlY3V0ZVJlY2hhcmdlIjp0cnVlLCJDYW5FeGVjdXRlU3RhdGVtZW50Ijp0cnVlLCJFbWFpbCI6InJvc2kudm9sZ2FyaW5AdGl2LXRlY25vbG9naWEuY29tIiwiRmlyc3ROYW1lIjoiUGFnYVNPIiwiTGFzdE5hbWUiOiJQYWdhU08iLCJNaWRkbGVOYW1lIjoiIiwiUGhvbmUiOiIiLCJUaGlyZFBhcnR5TmFtZSI6IlBhZ2FTTyJ9LCJhdWQiOlsiQWZyaWNlbGwiLCJQYWdhU08iXSwiZXhwIjoxNjYwODUwOTU0LCJpYXQiOjE2NjAyNDYxNTQsImlzcyI6ImFmcl9hb190Z3ciLCJqdGkiOiI2NyIsInN1YiI6IkFmcmljZWxsIFRHVyBCZWFyZXIgdG9rZW4ifQ.W2rhMBxX1lAf3BO2nGTjAWbrk4i71fgXxWm3-KRTng8ICJoveoEwmIV2haE_HmWxy0LH-xro5NWghP9QkgzF19qdJcWgtlhfquCDoe_6ww0O-f9QFvdu7bPZSRJq5n88PoE44GrTaNP_fygf8N4uUZbu7cNGDLwnt4gaXNuZzIFiWTL1hjlusGN-avsCWERYp5EShE1WlDTiYtMR7P2TER0sWG70DUFIb_UqD-8kqMu9VIpduyHrS07bEJVVkWUAZ5Roki-fl2z0R0Vz0ahR9bnECDjGqQvspmx4Q8xrfxyHkFOfIW0xYBmBfsgacjj95AHv7ILBzU4yPYpd4Hjnow" -d '{"TargetMSISDN":"244959560801", "TransactionReference":"220525120247", "TransactionId":"5", "Status":"", "Limit":20}' -X GET http://10.250.80.74:9214/HTTP_CheckTransactionLog/ -v 

Resposta de sucesso

 curl -H "Content-Type: application/json" -H "Authorization: Bearer eyJMb2dpbiI6IlBhZ2FTT0FkbWluIiwiVG9rZW5UeXBlIjoiUmVmcmVzaCIsImFsZyI6IlBTNTEyIiwidHlwIjoiSldTIn0.eyJTb3VyY2VJUCI6IjE3Mi4yNi4xMC42IiwiVXNlckluZm8iOnsiQ2FuQ3JlYXRlQVBJVXNlciI6ZmFsc2UsIkNhbkV4ZWN1dGVCYWxDaGVjayI6dHJ1ZSwiQ2FuRXhlY3V0ZVJlY2hhcmdlIjp0cnVlLCJDYW5FeGVjdXRlU3RhdGVtZW50Ijp0cnVlLCJFbWFpbCI6InJvc2kudm9sZ2FyaW5AdGl2LXRlY25vbG9naWEuY29tIiwiRmlyc3ROYW1lIjoiUGFnYVNPIiwiTGFzdE5hbWUiOiJQYWdhU08iLCJNaWRkbGVOYW1lIjoiIiwiUGhvbmUiOiIiLCJUaGlyZFBhcnR5TmFtZSI6IlBhZ2FTTyJ9LCJhdWQiOlsiQWZyaWNlbGwiLCJQYWdhU08iXSwiZXhwIjoxNjYwODUwOTU0LCJpYXQiOjE2NjAyNDYxNTQsImlzcyI6ImFmcl9hb190Z3ciLCJqdGkiOiI2NyIsInN1YiI6IkFmcmljZWxsIFRHVyBCZWFyZXIgdG9rZW4ifQ.W2rhMBxX1lAf3BO2nGTjAWbrk4i71fgXxWm3-KRTng8ICJoveoEwmIV2haE_HmWxy0LH-xro5NWghP9QkgzF19qdJcWgtlhfquCDoe_6ww0O-f9QFvdu7bPZSRJq5n88PoE44GrTaNP_fygf8N4uUZbu7cNGDLwnt4gaXNuZzIFiWTL1hjlusGN-avsCWERYp5EShE1WlDTiYtMR7P2TER0sWG70DUFIb_UqD-8kqMu9VIpduyHrS07bEJVVkWUAZ5Roki-fl2z0R0Vz0ahR9bnECDjGqQvspmx4Q8xrfxyHkFOfIW0xYBmBfsgacjj95AHv7ILBzU4yPYpd4Hjnow" -d '{"TargetMSISDN":"244959560801", "TransactionReference":"220525120247", "TransactionId":"5", "Status":"", "Limit":20}' -X GET http://10.250.80.74:9214/HTTP_CheckTransactionLog/ -v
* Expire in 0 ms for 6 (transfer 0x556c7cdcdfb0)
*   Trying 10.250.80.74...
* TCP_NODELAY set
* Expire in 200 ms for 4 (transfer 0x556c7cdcdfb0)
* Connected to 10.250.80.74 (10.250.80.74) port 9214 (#0)
> GET /HTTP_CheckTransactionLog/ HTTP/1.1
> Host: 10.250.80.74:9214
> User-Agent: curl/7.64.0
> Accept: */*
> Content-Type: application/json
> Authorization: Bearer eyJMb2dpbiI6IlBhZ2FTT0FkbWluIiwiVG9rZW5UeXBlIjoiUmVmcmVzaCIsImFsZyI6IlBTNTEyIiwidHlwIjoiSldTIn0.eyJTb3VyY2VJUCI6IjE3Mi4yNi4xMC42IiwiVXNlckluZm8iOnsiQ2FuQ3JlYXRlQVBJVXNlciI6ZmFsc2UsIkNhbkV4ZWN1dGVCYWxDaGVjayI6dHJ1ZSwiQ2FuRXhlY3V0ZVJlY2hhcmdlIjp0cnVlLCJDYW5FeGVjdXRlU3RhdGVtZW50Ijp0cnVlLCJFbWFpbCI6InJvc2kudm9sZ2FyaW5AdGl2LXRlY25vbG9naWEuY29tIiwiRmlyc3ROYW1lIjoiUGFnYVNPIiwiTGFzdE5hbWUiOiJQYWdhU08iLCJNaWRkbGVOYW1lIjoiIiwiUGhvbmUiOiIiLCJUaGlyZFBhcnR5TmFtZSI6IlBhZ2FTTyJ9LCJhdWQiOlsiQWZyaWNlbGwiLCJQYWdhU08iXSwiZXhwIjoxNjYwODUwOTU0LCJpYXQiOjE2NjAyNDYxNTQsImlzcyI6ImFmcl9hb190Z3ciLCJqdGkiOiI2NyIsInN1YiI6IkFmcmljZWxsIFRHVyBCZWFyZXIgdG9rZW4ifQ.W2rhMBxX1lAf3BO2nGTjAWbrk4i71fgXxWm3-KRTng8ICJoveoEwmIV2haE_HmWxy0LH-xro5NWghP9QkgzF19qdJcWgtlhfquCDoe_6ww0O-f9QFvdu7bPZSRJq5n88PoE44GrTaNP_fygf8N4uUZbu7cNGDLwnt4gaXNuZzIFiWTL1hjlusGN-avsCWERYp5EShE1WlDTiYtMR7P2TER0sWG70DUFIb_UqD-8kqMu9VIpduyHrS07bEJVVkWUAZ5Roki-fl2z0R0Vz0ahR9bnECDjGqQvspmx4Q8xrfxyHkFOfIW0xYBmBfsgacjj95AHv7ILBzU4yPYpd4Hjnow
> Content-Length: 116
>
* upload completely sent off: 116 out of 116 bytes
< HTTP/1.1 200 OK
< Content-Type: application/json
< Date: Thu, 11 Aug 2022 21:41:31 GMT
< Content-Length: 297
<
{"ReceiveDate":"2022-08-11T21:41:31.867761106Z","SourceIP":"172.26.10.6","Login":"PagaSOAdmin","ThirdPartyName":"PagaSO","DealerMSISDN":"244950170237","Transaction":null,"Status":"Successful","StatusCode":200,"StatusDescription":"OK","StatusDate":"2022-08-11T21:41:31.870360389Z","Elapsedtime":2}
* Connection #0 to host 10.250.80.74 left intact
┌─(~/PagasoAPP/pgstrans)(ruby-2.7.2)───────────────────────────────────────────────────────────────────────────────(pgsadmin@pgs-qa-all:pts/3)─┐


