Attribute VB_Name = "Main"

'Todas las rutinas deberán incluir una instancia de FlowOauth, es la que se encargará
'de solicitar un TOKEN DE ACCESO para consumir las Apis Google.

'Las respuestas que se reciben de las funciones son en formato JSON, estan son procesadas
'por el el módulo JsonConverter y después son pasadas por el módulo ProcessResponse
'para ser mostradas en texto plano, puede usarlo como guía para manipular las respuestas
'que son entregadas por parte del servidor. 


Sub copyTo_SpreadSheetSheet()
    
    'SpreadSheetSheet.CopyTo(spreadsheetsId,SheetId,destinationSpreadsheetId)
    'Copia un hoja en el mismo libro u otro.
    'param->string->spreadsheetsId->Libro de origen
    'param->integer->SheetId->Id de la hoja que se desea copiar.
    'param->string->destinationSpreadsheetId->Libro destino donde se pegará.
    'return->string->json


    Dim credentialsClient As String, credentialsToken As String, credentialsApiKey As String
    Dim oFlowOauth As New FlowOauth
    Dim oSpreadSheet As New SpreadSheetSheet
    Dim json As String
    Dim SheetId As Integer
    Dim spreadsheetsId As String
    Dim destinationSpreadsheetId As String
        
        
    credentialsClient = CurrentProject.Path + "\credentials\client_secret.json"
    credentialsToken = CurrentProject.Path + "\credentials\credentials_token.json"
    credentialsApiKey = CurrentProject.Path + "\credentials\api_key.json"
        
        
    spreadsheetsId = "1FC3AXegBhMeDWtjE-cPnVWlZAENLkOjXTueMWye7L4w"
    SheetId = 0
    destinationSpreadsheetId = "1FC3AXegBhMeDWtjE-cPnVWlZAENLkOjXTueMWye7L4w"
    
    oFlowOauth.InitializeFlow _
                            credentialsClient, _
                            credentialsToken, _
                            credentialsApiKey, _
                            OU_SCOPE_SPREADSHEETS

    With oSpreadSheet
        .ConnectionService oFlowOauth
         json = .CopyTo(spreadsheetsId, SheetId, destinationSpreadsheetId)
    End With
    
    Debug.Print json
    
End Sub

Sub get_GoogleSheetWorkBook()

    'SpreadSheetSheet.RecoveryById()
    'Recupera la información de libro a través del id.
    'param->string->spreadsheetsId->Id del libro que se desea recuperar.
    'return->string->json
    
    Dim credentialsClient As String, credentialsToken As String, credentialsApiKey As String
    Dim oFlowOauth As New FlowOauth
    Dim oSpreadSheet As New SpreadSheetSheet
    Dim oGoogleSheet As New GoogleSheetWorkBook
    Dim json As String
    Dim range As String
    Dim spreadsheetsId As String
    
    credentialsClient = CurrentProject.Path + "\credentials\client_secret.json"
    credentialsToken = CurrentProject.Path + "\credentials\credentials_token.json"
    credentialsApiKey = CurrentProject.Path + "\credentials\api_key.json"
    
    spreadsheetsId = "18Ady06ugiz971soeIpbuuBtrtwAugv9HXyMJs1Dun4I"
    
   oFlowOauth.InitializeFlow _
                            credentialsClient, _
                            credentialsToken, _
                            credentialsApiKey, _
                            OU_SCOPE_SPREADSHEETS
    
    With oSpreadSheet
        .ConnectionService oFlowOauth
         json = .RecoveryById(spreadsheetsId)
    End With
    
    With oGoogleSheet
        .Create json
        Debug.Print .Properties("title")
        Debug.Print .Sheets("title", 2)
        Debug.Print .Sheets("sheetId", 2)
    End With

End Sub

Sub get__SpreadSheetValue()
    
    'SpreadSheetValue.GetValue()
    'Recupera lo información contenida en las celdas de la hoja.
    'param->string->spreadsheetsId->Id del libro
    'param->string->[majordimension]->puede ser ROWS O COLUMNS, indica como se recuperará los datos, opción predeterminada es ROWS
    'param->string->[valueRenderOption]->Como debe presentarse la salida de los datos, la opción predeterminada es FORMATTED_VALUE.
    'param->string->[dateTimeRenderOption]->Como debe presentarse las horas y días en la respuesta, la opción predeterminada es SERIAL_NUMBER.
    'rerunr->string->json

    Dim credentialsClient As String, credentialsToken As String, credentialsApiKey As String
    Dim oFlowOauth As New FlowOauth
    Dim SpreadSG As New SpreadSheetValue
    Dim responseJSON As String
    Dim arrValue() As Variant
    Dim strValue As String
    Dim id As String
    Dim range As String
    
    credentialsClient = CurrentProject.Path + "\credentials\client_secret.json"
    credentialsToken = CurrentProject.Path + "\credentials\credentials_token.json"
    credentialsApiKey = CurrentProject.Path + "\credentials\api_key.json"
    
    id = "1FC3AXegBhMeDWtjE-cPnVWlZAENLkOjXTueMWye7L4w"
    range = "bbdd_libros"
    
    Rem comienza de el flujo de Oauth (autenticaci�n y autorizaci�n)
    oFlowOauth.InitializeFlow _
                               credentialsClient, _
                               credentialsToken, _
                               credentialsApiKey, _
                               OU_SCOPE_SPREADSHEETS
    
    Rem realizamos la consulta con GoogleSheets
    With SpreadSG
        .ConnectionService oFlowOauth
         responseJSON = .GetValue(id, range)
    End With
    
    If SpreadSG.Operation = GO_SUCCESSFUL Then
        Rem leemos la respuesta
        arrValue = ProcessResponse.GetValue(responseJSON)
         
        For i = LBound(arrValue, 1) To UBound(arrValue, 1)
            strValue = Empty
            For o = LBound(arrValue, 2) To UBound(arrValue, 2)
        Rem la estructura condicional solo es para obtener una
        Rem mejor vista de los datos puede obviarse junto con la funci�n ConsoleShow()
                If o = 0 Then
                    strValue = strValue & ConsoleShow(arrValue(i, o), 4)
                Else
                    strValue = strValue & ConsoleShow(arrValue(i, o), 25)
                End If
            Next o
            Debug.Print strValue
        Next i
    Else
        Debug.Print SpreadSG.DetailsError
    End If

End Sub

Sub update__SpreadSheetValue()

    'Actualizar los datos
    
    Dim credentialsClient As String, credentialsToken As String, credentialsApiKey As String
    Dim oFlowOauth As New FlowOauth
    Dim SpreadSG As New SpreadSheetValue
    Dim json As String
    Dim updateRangeValue As New Collection
    Dim id As String
    Dim range As String
    
    credentialsClient = CurrentProject.Path + "\credentials\client_secret.json"
    credentialsToken = CurrentProject.Path + "\credentials\credentials_token.json"
    credentialsApiKey = CurrentProject.Path + "\credentials\api_key.json"
    
    id = "1FC3AXegBhMeDWtjE-cPnVWlZAENLkOjXTueMWye7L4w"
    range = "BBDD_LIBROS!a12:d13"

    'se debe crear una colección con los datos, cada columna debe ir separada por una barra pipe.(Alt + 124)
    updateRangeValue.Add "12|Ataque a los titanes 34|9788467948158|Hajime Isayama"
    updateRangeValue.Add "13|Ataque a los titanes 33|9788467948158|Hajime Isayama"
    
    'Además de solo enviar texto, puede enviar fórmulas,como la que se muestra a continuación
    'updateRangeValue.Add "=QUERY(BBDD_LIBROS!A1:E;\""SELECT *\"";1)"
 
    oFlowOauth.InitializeFlow _
                                 credentialsClient, _
                                 credentialsToken, _
                                 credentialsApiKey, _
                                 OU_SCOPE_SPREADSHEETS
    
    With SpreadSG
        .ConnectionService oFlowOauth
         json = .Update(id, range, updateRangeValue, valueInputOption:="raw")
    End With
    
    If SpreadSG.Operation = GO_SUCCESSFUL Then
        Debug.Print ProcessResponse.UpdateValue(json)
    Else
        Debug.Print SpreadSG.DetailsError()
    End If
    
End Sub
Sub append__SpreadSheetvalue()
    
    Dim credentialsClient As String, credentialsToken As String, credentialsApiKey As String
    Dim oFlowOauth As New FlowOauth
    Dim SpreadSG As New SpreadSheetValue
    Dim json As String
    Dim appendRangeValue As New Collection
    Dim id As String
    Dim range As String
    
    credentialsClient = CurrentProject.Path + "\credentials\client_secret.json"
    credentialsToken = CurrentProject.Path + "\credentials\credentials_token.json"
    credentialsApiKey = CurrentProject.Path + "\credentials\api_key.json"
    
    id = "1FC3AXegBhMeDWtjE-cPnVWlZAENLkOjXTueMWye7L4w"
    range = "bbdd_libros"

    'Se agregará los datos al final de la tabla.
    appendRangeValue.Add "14|aplicaciones VBA con Excel|978612302653|Manuel Torres Remon"
    
    oFlowOauth.InitializeFlow _
                                 credentialsClient, _
                                 credentialsToken, _
                                 credentialsApiKey, _
                                 OU_SCOPE_SPREADSHEETS
    
    With SpreadSG
        .ConnectionService oFlowOauth
         json = .Append(id, range, appendRangeValue)
         
        If .Operation = GO_SUCCESSFUL Then
            Debug.Print ProcessResponse.AppendValue(json)
        Else
            Debug.Print .DetailsError()
        End If
    End With
    
End Sub

Sub clear__SpreadSheetValue()
    
    Dim credentialsClient As String, credentialsToken As String, credentialsApiKey As String
    Dim oFlowOauth As New FlowOauth
    Dim SpreadSG As New SpreadSheetValue
    Dim json As String
    
    Dim id As String
    Dim rng As String
    
    credentialsClient = CurrentProject.Path + "\credentials\client_secret.json"
    credentialsToken = CurrentProject.Path + "\credentials\credentials_token.json"
    credentialsApiKey = CurrentProject.Path + "\credentials\api_key.json"
    
    id = "1FC3AXegBhMeDWtjE-cPnVWlZAENLkOjXTueMWye7L4w"
    rng = "BBDD_LIBROS!a14:d14"

    oFlowOauth.InitializeFlow _
                                 credentialsClient, _
                                 credentialsToken, _
                                 credentialsApiKey, _
                                 OU_SCOPE_SPREADSHEETS
    
    With SpreadSG
        .ConnectionService oFlowOauth
         json = .Clear(id, rng)
         
         If .Operation = GO_SUCCESSFUL Then
            Debug.Print ProcessResponse.ClearValues(json)
         Else
            Debug.Print .DetailsError()
         End If
    End With
    
End Sub

Sub create_SpreadSheetSheet()

    Dim credentialsClient As String, credentialsToken As String, credentialsApiKey As String
    Dim oFlowOauth As New FlowOauth
    Dim SpreadSG As New SpreadSheetSheet
    Dim GoogleSheet As New GoogleSheetWorkBook
    Dim json As String
    
    credentialsClient = CurrentProject.Path + "\credentials\client_secret.json"
    credentialsToken = CurrentProject.Path + "\credentials\credentials_token.json"
    credentialsApiKey = CurrentProject.Path + "\credentials\api_key.json"
    
    oFlowOauth.InitializeFlow _
                                 credentialsClient, _
                                 credentialsToken, _
                                 credentialsApiKey, _
                                 OU_SCOPE_SPREADSHEETS
    
    With SpreadSG
        .ConnectionService oFlowOauth
        json = .CreateWorkBook()
    End With
    
    
    With GoogleSheet
        .Create json
        Debug.Print "datos generales"
        Debug.Print "url : "; .SpreadSheetUrl
        Debug.Print "ID : "; .SpreadsheetId
        Debug.Print "nombre libro--> "; .Properties("title")
        Debug.Print "Local--> "; .Properties("locale")
        Debug.Print "Zona Horaria--> "; .Properties("timeZone")
        
        Debug.Print "Datos de la hoja : "
        Debug.Print "Nombre de la hoja--> "; .Sheets("title", 1)
        Debug.Print "Id de la hoja--> "; .Sheets("sheetId")
        Debug.Print "Indice de la hoja--> "; .Sheets("index")
        Debug.Print "Tipo de la hoja--> "; .Sheets("sheetType")
        
        Shell "cmd.exe /k start chrome.exe " & .SpreadSheetUrl, vbHide
        
    End With
    
End Sub

Sub create_SpreadSheetSheet_with_collections()
    
    Dim credentialsClient As String, credentialsToken As String, credentialsApiKey As String
    Dim oFlowOauth As New FlowOauth
    Dim SpreadSG As New SpreadSheetSheet
    Dim GoogleSheet As New GoogleSheetWorkBook
    Dim json As String
    
    credentialsClient = CurrentProject.Path + "\credentials\client_secret.json"
    credentialsToken = CurrentProject.Path + "\credentials\credentials_token.json"
    credentialsApiKey = CurrentProject.Path + "\credentials\api_key.json"
    
    oFlowOauth.InitializeFlow _
                                 credentialsClient, _
                                 credentialsToken, _
                                 credentialsApiKey, _
                                 OU_SCOPE_SPREADSHEETS
    
    With SpreadSG
        .ConnectionService oFlowOauth
        json = .CreateWorkBook()
    End With
    
    
    With GoogleSheet
        .Create json
        
        For i = 1 To .GoogleSheets.Count
            With .GoogleSheets
                Debug.Print .Count
                Debug.Print .Item(i).Title
                Debug.Print .Item(i).SheetId
                
                Debug.Print .Item(i).gridProperties.ColumnCount
                Debug.Print .Item(i).gridProperties.RowCount
            End With
            Debug.Print " ----- Fin " & .GoogleSheets.Item(i).Title & " -------------" & vbCrLf
        Next i
        
        Debug.Print .Properties("title")
        Debug.Print .SpreadsheetId
        Debug.Print .SpreadSheetUrl
    End With
    
End Sub
Sub recovery_SpreadSheetSheet_with_collections()
    
    Dim credentialsClient As String, credentialsToken As String, credentialsApiKey As String
    Dim oFlowOauth As New FlowOauth
    Dim SpreadSG As New SpreadSheetSheet
    Dim GoogleSheet As New GoogleSheetWorkBook
    Dim json As String
    Dim id As String
    
    credentialsClient = CurrentProject.Path + "\credentials\client_secret.json"
    credentialsToken = CurrentProject.Path + "\credentials\credentials_token.json"
    credentialsApiKey = CurrentProject.Path + "\credentials\api_key.json"
    
    oFlowOauth.InitializeFlow _
                                 credentialsClient, _
                                 credentialsToken, _
                                 credentialsApiKey, _
                                 OU_SCOPE_SPREADSHEETS
    
    id = "1FC3AXegBhMeDWtjE-cPnVWlZAENLkOjXTueMWye7L4w"
    
    With SpreadSG
        .ConnectionService oFlowOauth
        json = .RecoveryById(id)
    End With
    
    
    With GoogleSheet
        .Create json
        
        For i = 1 To .GoogleSheets.Count
            With .GoogleSheets
                Debug.Print "Este libro contiene "; .Count; " hojas"
                Debug.Print "Nombre de la hoja "; .Item(i).Title
                Debug.Print "SheetId "; .Item(i).SheetId
                
                Debug.Print "Columnas "; .Item(i).gridProperties.ColumnCount
                Debug.Print "Filas "; .Item(i).gridProperties.RowCount
            End With
            Debug.Print " ----- Fin " & .GoogleSheets.Item(i).Title & " -------------" & vbCrLf
        Next i
        
        Debug.Print "Nombre del libro "; .Properties("title")
        Debug.Print "Id del libro "; .SpreadsheetId
        Debug.Print "Url del libro "; .SpreadSheetUrl
    End With
    
End Sub


Sub batchUpdate_SpreadSheetSheet()
    
    Dim credentialsClient As String, credentialsToken As String, credentialsApiKey As String
    Dim SpreadSG As New SpreadSheetSheet
    Dim requets As New Collection
    Dim gf_FindReplace As unionFieldScope
'    Dim gf_DeleteRange As unionFieldScope
    Dim json As String
    Dim text As String
    Dim id As String
    
    Dim oFlowOauth As New FlowOauth
    
    credentialsClient = CurrentProject.Path + "\credentials\client_secret.json"
    credentialsToken = CurrentProject.Path + "\credentials\credentials_token.json"
    credentialsApiKey = CurrentProject.Path + "\credentials\api_key.json"
    
    id = "1FC3AXegBhMeDWtjE-cPnVWlZAENLkOjXTueMWye7L4w"
    
    oFlowOauth.InitializeFlow _
                                 credentialsClient, _
                                 credentialsToken, _
                                 credentialsApiKey, _
                                 OU_SCOPE_SPREADSHEETS
    
    With gf_FindReplace.rng
        .SheetId = 0
        .startRowIndex = 1
        .endRowIndex = 25
        .startColumnIndex = 0
        .endColumnIndex = 5
    End With
    
    With SpreadSG
        .ConnectionService oFlowOauth
        find_replace = .FindReplace("852963741", "2099", gf_FindReplace)

        requets.Add find_replace

        json = .batchUpdate(id, requets)
        
        If .Operation = GO_SUCCESSFUL Then
            Debug.Print "Actualizaci�n aplicada a : "; ProcessResponse.batchUpdate(json)
        Else
            Debug.Print "No se pudo actualizar"
        End If
    End With

End Sub

