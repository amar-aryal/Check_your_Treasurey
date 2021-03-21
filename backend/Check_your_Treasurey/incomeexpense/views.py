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

        # income_category_list = Income.objects.filter(userID = self.request.user,date__year=year, date__month=month).values_list('category',flat=True) #flat = True returns a single value instead of list or tuple

        # income_category_info = {}

        # for cat in income_category_list:
        #     cat_income = Income.objects.filter(userID = self.request.user,date__year=year, date__month=month, category=cat).aggregate(total=Sum('amount'))["total"]
        #     income_category_info[cat] = cat_income

        # """FOR EXPENSE"""
        # expense_category_list = Expense.objects.filter(userID = self.request.user,date__year=year, date__month=month).values_list('category',flat=True) #flat = True returns a single value instead of list or tuple

        # expense_category_info = {}

        # for cat in expense_category_list:
        #     cat_expense = Expense.objects.filter(userID = self.request.user,date__year=year, date__month=month, category=cat).aggregate(total=Sum('amount'))["total"]
        #     expense_category_info[cat] = cat_expense

    # Create a file-like buffer to receive PDF data.
        buffer = io.BytesIO()

        # Create the PDF object, using the buffer as its "file."
        p = canvas.Canvas(buffer)

        # Draw things on the PDF. Here's where the PDF generation happens.
        # See the ReportLab documentation for the full list of functionality.
        p.drawString(100, 500, "Total Income: "+str(total_monthly_income))
        p.drawString(100, 700, "Total Expenses: "+str(total_monthly_expense))
        p.drawString(100, 800, "Total Savings: "+str(savings))

        # Close the PDF object cleanly, and we're done.
        p.showPage()
        p.save()

        # FileResponse sets the Content-Disposition header so that browsers
        # present the option to save the file.
        buffer.seek(0)
        return FileResponse(buffer, as_attachment=True, filename='Report.pdf')


from . import mycharts
        
def barchart(request):

    #instantiate a drawing object
    d = mycharts.MyBarChartDrawing()

    #extract the request params of interest.
    #I suggest having a default for everything.
    if 'height' in request:
        d.height = int(request['height'])
    if 'width' in request:
        d.width = int(request['width'])
    
    if 'numbers' in request:
        strNumbers = request['numbers']
        numbers = map(int, strNumbers.split(','))    
        d.chart.data = [numbers]   #bar charts take a list-of-lists for data

    if 'title' in request:
        d.title.text = request['title']
  

    #get a GIF (or PNG, JPG, or whatever)
    binaryStuff = d.asString('gif')
    return HttpResponse(binaryStuff, 'image/gif')

