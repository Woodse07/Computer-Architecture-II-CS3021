// This code takes 1.2ms to execute
// How did I measure this? 
// 1. Made a shell script to run this program 10,000 times.
// 2. Executed the shell script with the time command in linux.
// 3. Found the average.

#include <stdio.h>

int procedureCount = 0;
int depth = 0;
int currentWindowCount = 0;
int overflow = 0;
int underflow = 0;
int max = 0;
int temp = 0;


int ackermannX(int x, int y) {
	procedureCount++;
	depth++;
	if(currentWindowCount == 16) { overflow++; }
	else currentWindowCount++;
	if(depth > max) max = depth;
	if(x == 0) {
		depth--;
		if(currentWindowCount == 2) { underflow++; }
		else currentWindowCount--;
		return y+1;
	}
	else if (y == 0) {
		temp = ackermannX(x-1, 1);
		depth--;
		if(currentWindowCount == 2) { underflow++; }
		else currentWindowCount--;
		return temp;
	}
	else {
		temp = ackermannX(x-1, ackermannX(x, y-1));
		depth--;
		if(currentWindowCount == 2) { underflow++; }
		else currentWindowCount--;
		return temp;
	}
}

int ackermann(int x, int y) {
	if(x == 0) return y+1;
	else if(y == 0) return ackermann(x-1, 1);
	else return ackermann(x-1, ackermann(x, y-1));
}

int main() {
		int x = 3;
	int y = 6;
	int result = ackermannX(x, y);
	printf("Result: %d\n", result);
	printf("Procedure count: %d\n", procedureCount);
	printf("Max window depth: %d\n", max);
	printf("Overflow: %d\n", overflow);
	printf("Underflow: %d\n", underflow);

}
