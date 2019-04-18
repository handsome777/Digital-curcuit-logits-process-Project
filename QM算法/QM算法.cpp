#include<fstream>
#include<iostream>
#include<stdio.h>
#include<algorithm>
using namespace std;
#define v_Max 10

struct M
{
	int decimal;
	char binary[10];
	int amount;
	int all_decimal[100];
	bool stage;
	int level;

};

void count_binary(M &m,int d,int var)
{
	char trans[10];
	itoa(d,trans,2);
	int length=strlen(trans);
	char n[]="0",lo[11]="";
	if(length<var)
		{
			for(int i=0;i<var-length;i++)
				strcat(lo,n);
		}
	strcat(lo,trans);
	strcpy(m.binary,lo);
	int count=0;
	for(int i=0;i<var;i++)
		{
			if(lo[i]=='1')
				count++;
		}
	m.amount=count;
	m.stage=false;
}

int compare(M &a,M &b,int var)
{
	int count=0,k;
	for(int i=0;i<var;i++)
		{
			if(a.binary[i]!=b.binary[i])
				{
					count++;
					k=i;
				}
		}
	if(count==1)
		return k;
	else
		return -1;
}

int get_num(int a)
{
	int sum=1;
	for(int i=0;i<a;i++)
		sum=sum*2;
	return sum;
}

int simply(M *m,int length,int row)
{
	int k=get_num(row+1);
	for(int i=0;i<length;i++)
		{
			for(int j=i+1;j<length;j++)
				{
					for(int q=0;q<k;q++)
						{
							if(strcmp(m[i].binary,m[j].binary)==0)
								{
									for(int z=j;z<length;z++)
										{
											m[z]=m[z+1];
										}
									length--;
								}
						}
				}
		}
	return length;
}

void shuchu(M m,int var)
{
	char a='A';
	char b;
	for(int i=0;i<var;i++)
		{
			if(m.binary[i]=='1')
				{
					b=a+i;
					cout<<b;
				}
			if(m.binary[i]=='1'-1)
				{
					b=a+i;
					cout<<b<<"'";
				}
			if(m.binary[i]=='-')
				continue;
		}
}


int main()
{
	ifstream op("test_case.txt",ios::in);
	int variable,min_num,extral_num;
	op>>variable>>min_num;
	int min[100],extral[100];
	for(int i=0;i<min_num;i++)
		{
			op>>min[i];
		}
	op>>extral_num;
	for(int i=0;i<extral_num;i++)
		{
			op>>extral[i];
		}
	M line[30];
	for(int i=0;i<min_num;i++)
		{
			line[i].decimal=min[i];
			count_binary(line[i],min[i],variable);
		}
	for(int i=min_num;i<min_num+extral_num;i++)
		{
			line[i].decimal=extral[i-min_num];
			count_binary(line[i],extral[i-min_num],variable);
		}
	M range[10][50];
	//两两合并
	int jishu=0;
	for(int i=0;i<min_num+extral_num;i++)
		{
			for(int j=i+1;j<min_num+extral_num;j++)
				{
					int flag=compare(line[i],line[j],variable);
					if(flag!=-1)
						{
							strcpy(range[0][jishu].binary,line[i].binary);
							range[0][jishu].binary[flag]='-';
							range[0][jishu].all_decimal[0]=line[i].decimal;
							range[0][jishu].all_decimal[1]=line[j].decimal;
							sort(range[0][jishu].all_decimal,range[0][jishu].all_decimal+2);
							range[0][jishu].stage=false;
							range[0][jishu].level=0;
							jishu++;
						}
				}
		}

	M no_combine[50];
	int no_flag=0;

	int max;
	int ordor_num[10];
	ordor_num[0]=jishu;
	for(int i=0;i<variable-1;i++)
		{
			max=i;
			int count=0;

			//开始匹配
			for(int j=0;j<jishu;j++)
				{
					for(int z=j+1;z<jishu;z++)
						{
							int flag=compare(range[i][j],range[i][z],variable);
							if(flag!=-1)
								{
									strcpy(range[i+1][count].binary,range[i][j].binary);
									range[i+1][count].binary[flag]='-';
									int index=get_num(i+1);
									for(int q=0;q<index;q++)
										{
											range[i+1][count].all_decimal[q]=range[i][j].all_decimal[q];
										}
									for(int q=index;q<2*index;q++)
										{
											range[i+1][count].all_decimal[q]=range[i][z].all_decimal[q-index];
										}
									range[i+1][count].stage=false;
									sort(range[i+1][count].all_decimal,range[i+1][count].all_decimal+index*2);
									range[i][j].stage=true;
									range[i][z].stage=true;
									range[i+1][count].level=i+1;
									count++;
								}
						}
					if(range[i][j].stage==false)
						{
							no_combine[no_flag]=range[i][j];
							no_flag++;
						}
				}
			//匹配结束

		
			//如果下一排没有元素了
			if(count==0)
				break;
			else
				{
					count=simply(range[i+1],count,i+1);
					jishu=count;
					ordor_num[i+1]=jishu;
				}
		}

	M essential[50];
	int essential_num=0;
	int non_essential_flag=0;

	for(int i=0;i<min_num;i++)
		{
			int r=0;
			int d=-1;
			for(int j=0;j<no_flag;j++)
				{
					int g=get_num(no_combine[j].level+1);
					for(int z=0;z<g;z++)
						{
							if(min[i]==no_combine[j].all_decimal[z])
								{
									r++;
									d=j;
								}
						}
				}
			if(r==1) 
				{
					essential[essential_num]=no_combine[d];
					essential_num++;
				}
		}
	//需要简化一下本之本源项
	for(int i=0;i<essential_num;i++)
		{
			for(int j=i+1;j<essential_num;j++)
				{
					if(strcmp(essential[i].binary,essential[j].binary)==0)
						{
							for(int z=j+1;z<essential_num;z++)
							{
								essential[z-1]=essential[z];
							}
							essential_num--;
						}
				}
		}


	//下面寻找非本质本源项
	for(int i=0;i<no_flag;i++)
		{
			for(int j=0;j<essential_num;j++)
				{
					if(strcmp(no_combine[i].binary,essential[j].binary)==0)
						{
							for(int z=j;z<no_flag;z++)
								{
									no_combine[z]=no_combine[z+1];
								}
							no_flag--;
						}
				}
		}

	//把本之本源蕴含项包含的排除出去
	for(int i=0;i<essential_num;i++)
		{
			int k=get_num(essential[i].level+1);
			for(int j=0;j<k;j++)
				{
					for(int z=0;z<min_num;z++)
						{
							if(min[z]==essential[i].all_decimal[j])
								{
									for(int w=z;w<min_num;w++)
										{
											min[w]=min[w+1];
										}
									min_num--;
								}
						}
				}
		}

	//下面开始遍历，寻找非本质本源蕴含项的最小覆盖
	int all=get_num(no_flag);
	char search[30000][20];
	for(int i=0;i<all;i++)
		{
			char trans[20];
			itoa(i,trans,2);
			int length=strlen(trans);
			char n[]="0",lo[20]="";
			if(length<no_flag)
				{
					for(int i=0;i<no_flag-length;i++)
						strcat(lo,n);
				}
			strcat(lo,trans);
			strcpy(search[i],lo);
		}

	char record[100];

	for(int i=0;i<all;i++)
		{
			int r[100];
			int c=0;
			for(int j=0;j<no_flag;j++)
				{
					if(search[i][j]=='1')
						{
							int k=get_num(no_combine[j].level+1);
							for(int z=c;z<c+k;z++)
								{
									r[z]=no_combine[j].all_decimal[z-c];
								}
							c=c+k;
						}
				}
			//把重复的缩减下去
			for(int p=0;p<c;p++)
				{
					for(int u=p+1;u<c;u++)
						{
							if(r[p]==r[u])
								{
									for(int t=u;t<c;t++)
										{
											r[u]=r[u+1];
											c--;
										}
								}
					}
				}

			bool judge=false;
			bool ju=false;
			//下面判断是否包含了剩余的最小项
			for(int p=0;p<min_num;p++)
				{
					judge=false;
					for(int u=0;u<c;u++)
						{
							if(min[p]==r[u])
								{
									judge=true;
									break;
								}
						}
					if(judge==false)
						break;
					if(p==min_num-1&&judge==true)
						{
							ju=true;
							break;
						}
				}
			if(ju==true)
				{
					strcpy(record,search[i]);
					break;
				}
		}
	M im[20];
	int im_flag=0;
	for(int i=0;i<no_flag;i++)
		{
			if(record[i]=='1')
				{
					im[im_flag]=no_combine[i];
					im_flag++;
				}
		}
	for(int i=0;i<essential_num;i++)
		{
			shuchu(essential[i],variable);
			if(i!=essential_num-1)
				cout<<"+";
		}
	if(im_flag!=0)
		{
			cout<<"+";
			for(int i=0;i<im_flag;i++)
				{
					shuchu(im[i],variable);
					if(i!=im_flag-1)
						cout<<"+";
				}
		}
	return 0;
}