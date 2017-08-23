Attribute VB_Name = "ExcelToGChart"
Option Explicit

Sub Excel_Data_To_Json_GChart()

    Dim fs As Object
    Dim FilePath
    Dim data As String
    Dim aRange As Range
    Dim r, c As Long
    Dim dataType As String
    
        
    On Error Resume Next
    Set aRange = Application.InputBox(prompt:="Enter range (Header Include)", Type:=8)
    
    If aRange Is Nothing Then
        MsgBox "Operation Cancelled"
    Else
    
        With aRange
        .Replace What:="""", Replacement:="", LookAt:=xlPart, SearchOrder:=xlByRows, MatchCase:=False, SearchFormat:=False, ReplaceFormat:=False
        End With
        
        Set fs = CreateObject("Scripting.FileSystemObject")

        'Path
        Set FilePath = fs.CreateTextFile(ThisWorkbook.Path & "\Data.json", True)
        
'COLS
            data = "{"
            FilePath.WriteLine data
            
            data = """" & "cols" & """" & ":" & "["
            FilePath.WriteLine data
            
        For c = 1 To aRange.Columns.Count
            data = ""
            dataType = ""
            If VarType(aRange.Cells(2, c)) = 8 Then 'Check VarType Function (TEXT)
                dataType = "string"
                data = data & c & "," & """label" & """" & ":" & """" & aRange.Cells(1, c) & """" & "," & """" & "type" & """" & ":" & """" & dataType & """"
            Else
                dataType = "number"
                data = data & c & "," & """label" & """" & ":" & """" & aRange.Cells(1, c) & """" & "," & """" & "type" & """" & ":" & """" & dataType & """"
            End If
            
                data = Left(data, Len(data) - 0)
                If c = aRange.Columns.Count Then
                    data = "{" & """" & "id" & """" & ":" & data & "}"
                Else
                    data = "{" & """" & "id" & """" & ":" & data & "},"
                End If
       
            FilePath.WriteLine data
        Next
    
            data = "],"
            FilePath.WriteLine data
            
'ROWS
            
            data = """" & "rows" & """" & ":" & "["
            FilePath.WriteLine data
            
        For r = 2 To aRange.Rows.Count
            data = ""
            For c = 1 To aRange.Columns.Count
                If aRange(r, c) = vbNullString Then 'If data empty
                    data = data & "{" & """" & "v" & """" & ":" & "null" & "}" & ","
                Else
                    If VarType(aRange.Cells(r, c)) = 8 Then 'Check VarType Function (TEXT)
                        data = data & "{" & """" & "v" & """" & ":" & """" & aRange.Cells(r, c) & """" & "}" & ","
                    Else
                        data = data & "{" & """" & "v" & """" & ":" & aRange.Cells(r, c) & "}" & ","
                    End If
                End If
            Next
            data = Left(data, Len(data) - 1)
                If r = aRange.Rows.Count Then
                    data = "{" & """" & "c" & """" & ":" & "[" & data & "]" & "}"
                Else
                    data = "{" & """" & "c" & """" & ":" & "[" & data & "]" & "},"
                End If
       
            FilePath.WriteLine data
        Next
        
            data = "]"
            FilePath.WriteLine data
            data = "}"
            FilePath.WriteLine data
            FilePath.Close
   
        Set fs = Nothing
    End If
End Sub
