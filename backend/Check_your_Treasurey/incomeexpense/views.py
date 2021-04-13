from django.shortcuts import render

from .models import Income,Expense
from .serializers import IncomeSerializer,ExpenseSerializer
from rest_framework.views import APIView
from rest_framework.views import Response
from rest_framework.permissions import IsAuthenticated
from .permissions import IsOwner
from rest_framework import status
from rest_framework import generics
from django.contrib.auth.models import User
from datetime import date
from django.db.models.aggregates import Sum
from django.core.mail import send_mail

import io
from django.http import FileResponse, HttpResponse
from reportlab.pdfgen import canvas
from reportlab.graphics.shapes import Drawing, String
from reportlab.graphics.charts.barcharts import HorizontalBarChart

import xlwt


class IncomeList(generics.ListCreateAPIView): # for listing the incomes and creating incomes
    
    # def get(self,request,format=None):
    #     incomes = Income.objects.all()
    #     serializer = IncomeSerializer(incomes, many=True)
    #     return Response(serializer.data)

    # def get_queryset(self, pk):
    #     try:
    #         income = Income.objects.get(pk=pk)
    #     except Income.DoesNotExist:
    #         content = {
    #             'status': 'Not Found'
    #         }
    #         return Response(content, status=status.HTTP_404_NOT_FOUND)
    #     return income

    # def post(self,request,format=None):
    #     serializer = IncomeSerializer(data=request.data)
    #     if serializer.is_valid():
    #         serializer.save()
    #         return Response(serializer.data, status=status.HTTP_201_CREATED)
    #     return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    permission_classes = (IsAuthenticated,IsOwner)
    queryset = Income.objects.all()
    serializer_class = IncomeSerializer

    def get_queryset(self):
        """Returns objects for current authenticated user only and the date passed as url parameter"""
        return self.queryset.filter(userID=self.request.user, date=self.request.query_params.get('date', None))
    
    def perform_create(self, serializer):
        """Assigns the logged in user's id to the object's userID foreign key"""
        serializer.save(userID=self.request.user)
        
class IncomeRUD(generics.RetrieveUpdateDestroyAPIView): # for update and delete income
    permission_classes = (IsAuthenticated,IsOwner)
    queryset = Income.objects.all()
    serializer_class = IncomeSerializer


class ExpenseList(generics.ListCreateAPIView):
    permission_classes = (IsAuthenticated,IsOwner)
    queryset = Expense.objects.all()
    serializer_class = ExpenseSerializer

    def get_queryset(self):
        """Returns objects for current authenticated user only and the date passed as url parameter"""
        return self.queryset.filter(userID=self.request.user, date=self.request.query_params.get('date', None))

    
    def perform_create(self, serializer):
        """Assigns the logged in user's id to the object's userID foreign key"""
        serializer.save(userID=self.request.user)
    
class ExpenseRUD(generics.RetrieveUpdateDestroyAPIView):
    permission_classes = (IsAuthenticated,IsOwner)
    queryset = Expense.objects.all()
    serializer_class = ExpenseSerializer

"""this view returns the total income and expense of a user at the parameter date"""
class IncomeExpenseDailyStats(APIView):
    permission_classes = (IsAuthenticated,IsOwner)
    
    def get(self,request):
        total_income = Income.objects.filter(userID = self.request.user,date=self.request.query_params.get('date', None)).aggregate(total=Sum('amount'))["total"]
        total_expense = Expense.objects.filter(userID = self.request.user,date=self.request.query_params.get('date', None)).aggregate(total=Sum('amount'))["total"]

        return Response({'today_total_income':total_income, 'today_total_expense':total_expense}, status=status.HTTP_200_OK)

class MonthlyStats(APIView):

    """Options: use query param to get monthly data OR fetch data for all the months and display in required places"""

    permission_classes = (IsAuthenticated,IsOwner)

    def get(self,request):
        """getting the year and month from the url as parameters"""

        year = self.request.query_params.get('year')
        month = self.request.query_params.get('month')


        """Calculating the total income and expenses of the url passed month-year"""

        total_monthly_income = Income.objects.filter(userID = self.request.user, date__year=year, date__month=month).aggregate(total=Sum('amount'))["total"]
        total_monthly_expense = Expense.objects.filter(userID = self.request.user, date__year=year, date__month=month).aggregate(total=Sum('amount'))["total"]
        savings = 0

        if total_monthly_expense is not None and total_monthly_income is not None:
            if total_monthly_income > total_monthly_expense:
                savings = total_monthly_income - total_monthly_expense
            else:
                savings = 0
            

        """Now calculating the total spending and income in each category for report and chart"""

        """FOR INCOME"""

        income_category_list = Income.objects.filter(userID = self.request.user,date__year=year, date__month=month).values_list('category',flat=True) #flat = True returns a single value instead of list or tuple

        income_category_info = {}

        for cat in income_category_list:
            cat_income = Income.objects.filter(userID = self.request.user,date__year=year, date__month=month, category=cat).aggregate(total=Sum('amount'))["total"]
            income_category_info[cat] = cat_income

        """FOR EXPENSE"""
        expense_category_list = Expense.objects.filter(userID = self.request.user,date__year=year, date__month=month).values_list('category',flat=True) #flat = True returns a single value instead of list or tuple

        expense_category_info = {}

        for cat in expense_category_list:
            cat_expense = Expense.objects.filter(userID = self.request.user,date__year=year, date__month=month, category=cat).aggregate(total=Sum('amount'))["total"]
            expense_category_info[cat] = cat_expense

        return Response({'total_income':total_monthly_income, 'total_expenses':total_monthly_expense,'savings':savings,'income_details':income_category_info, 'expense_details':expense_category_info}, status=status.HTTP_200_OK)

class ReportPdfView(APIView):

    permission_classes = (IsAuthenticated,IsOwner)

    def get(self,request):

        year = self.request.query_params.get('year')
        month = self.request.query_params.get('month')


        """Calculating the total income and expenses of the url passed month-year"""

        total_monthly_income = Income.objects.filter(userID = self.request.user,date__year=year, date__month=month).aggregate(total=Sum('amount'))["total"]
        total_monthly_expense = Expense.objects.filter(userID = self.request.user,date__year=year, date__month=month).aggregate(total=Sum('amount'))["total"]
        savings = 0

        if total_monthly_expense is not None and total_monthly_income is not None:
            if total_monthly_income > total_monthly_expense:
                savings = total_monthly_income - total_monthly_expense
            else:
                savings = 0
            

        """Now calculating the total spending and income in each category for report and chart"""

        """FOR INCOME"""

        income_category_list = Income.objects.filter(userID = self.request.user,date__year=year, date__month=month).values_list('category',flat=True) #flat = True returns a single value instead of list or tuple

        income_category_info = {}

        for cat in income_category_list:
            cat_income = Income.objects.filter(userID = self.request.user,date__year=year, date__month=month, category=cat).aggregate(total=Sum('amount'))["total"]
            income_category_info[cat] = cat_income

        """FOR EXPENSE"""
        expense_category_list = Expense.objects.filter(userID = self.request.user,date__year=year, date__month=month).values_list('category',flat=True) #flat = True returns a single value instead of list or tuple

        expense_category_info = {}

        for cat in expense_category_list:
            cat_expense = Expense.objects.filter(userID = self.request.user,date__year=year, date__month=month, category=cat).aggregate(total=Sum('amount'))["total"]
            expense_category_info[cat] = cat_expense

    # Create a file-like buffer to receive PDF data.
        buffer = io.BytesIO()

        # Create the PDF object, using the buffer as its "file."
        p = canvas.Canvas(buffer)
        p.setPageSize((600,1000))

        p.setFont('Helvetica',24)

        # Draw things on the PDF. Here's where the PDF generation happens.
        # See the ReportLab documentation for the full list of functionality.
        p.drawString(180, 950, "Monthly report - "+month+"/"+year)
        p.drawString(180, 900, "Total Income: "+str(total_monthly_income))
        p.drawString(180, 850, "Total Expenses: "+str(total_monthly_expense))
        p.drawString(180, 800, "Total Savings: "+str(savings))
        p.drawString(50, 700, "Incomes per Category")
        p.drawString(320, 700, "Expenses per Category")
        p.line(300,730,300,50)

        """Iterating throgh income and expenses category dictionary to get data ready for pdf"""

        yInc = 100
        for key, value in income_category_info.items():
            p.drawString(48, yInc, str(key) +  ' = ' +str(value))
            yInc=yInc+50

        yExp = 100
        for key, value in expense_category_info.items():
            p.drawString(320, yExp, str(key) +  ' = ' +str(value))
            yExp=yExp+50

        # Close the PDF object cleanly, and we're done.
        p.showPage()
        p.save()

        # FileResponse sets the Content-Disposition header so that browsers
        # present the option to save the file.
        buffer.seek(0)
        return FileResponse(buffer, as_attachment=True, filename='Report.pdf')

class ExportToExcel(APIView):

    permission_classes = (IsAuthenticated,IsOwner)


    def get(self,request):

        year = self.request.query_params.get('year')
        month = self.request.query_params.get('month')

        response = HttpResponse(content_type='application/ms-excel')
        response['Content-Disposition'] = 'attachment; filename="ExcelReport.xls"'

        wb = xlwt.Workbook(encoding='utf-8')
        ws = wb.add_sheet('Monthly-Report')


        # Sheet header, first row
        row_num = 0

        font_style = xlwt.XFStyle()
        font_style.font.bold = True
        font_style.num_format_str = 'DD-MM-YYYY'

        columns = ['Month/Year','Total Income','Total Expense', 'Savings', ]

        #writing header columns
        for col_num in range(len(columns)):
            ws.write(row_num, col_num, columns[col_num], font_style)

        # Sheet body, remaining rows
        font_style = xlwt.XFStyle()
        # font_style.num_format_str = 'yyyy-mm-dd'

        """ First writing total income, expenses and saving for a month"""

        total_monthly_income = Income.objects.filter(userID = self.request.user,date__year=year, date__month=month).aggregate(total=Sum('amount'))["total"]
        total_monthly_expense = Expense.objects.filter(userID = self.request.user,date__year=year, date__month=month).aggregate(total=Sum('amount'))["total"]
        savings = 0

        if total_monthly_expense is not None and total_monthly_income is not None:
            if total_monthly_income > total_monthly_expense:
                savings = total_monthly_income - total_monthly_expense
            else:
                savings = 0

        ws.write(1,0,str(month)+"/"+str(year))
        ws.write(1,1,total_monthly_income)
        ws.write(1,2,total_monthly_expense)
        ws.write(1,3,savings)

        ws.write(3,0,"Income list")

        ws.write(4,0,"Income name")
        ws.write(4,1,"Category")
        ws.write(4,2,"Amount")
        ws.write(4,3,"Date")

        """Now detail data of income and expense """

        rows = Income.objects.filter(userID = self.request.user,date__year=year, date__month=month).values_list('incomename','category','amount','date')
        row_num = 5
        for row in rows:
            row_num += 1
            for col_num in range(len(row)):
                ws.write(row_num, col_num, row[col_num], font_style)

        """gap of rows between income and expense data"""
        row_num += 6
        ws.write(row_num-1,0,"Expense list")
        ws.write(row_num,0,"Expense name")
        ws.write(row_num,1,"Category")
        ws.write(row_num,2,"Amount")
        ws.write(row_num,3,"Date")

        rows1 = Expense.objects.filter(userID = self.request.user,date__year=year, date__month=month).values_list('expensename','category','amount','date')
        
        row_num += 1
        for row in rows1:
            row_num += 1
            for col_num in range(len(row)):
                ws.write(row_num, col_num, row[col_num], font_style)

        wb.save(response)
        return response

class RecentExpenses(APIView):
    queryset = Expense.objects.all()
    serializer_class = ExpenseSerializer
    permission_classes = (IsAuthenticated,IsOwner)


    def get(self,request):
        data = self.queryset.filter(userID=self.request.user,date__year=date.today().year,date__month=date.today().month).values()

        return Response(data, status=status.HTTP_200_OK)

class RecentIncomes(APIView):
    queryset = Income.objects.all()
    serializer_class = IncomeSerializer
    permission_classes = (IsAuthenticated,IsOwner)


    def get(self,request):
        data = self.queryset.filter(userID=self.request.user,date__year=date.today().year,date__month=date.today().month).values()

        return Response(data, status=status.HTTP_200_OK)        



