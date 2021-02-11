#define MAX_SIZE 500


#include <iostream>

using namespace std;

/*	*@param int num sum value we try to get
*	*@paraö int arr array 
*	*@param last index 
*	*@return 1 or 0
*	*if get sum value return 1 else return 0
*/	
int CheckSumPossibility(int num, int arr[], int last_index) {
    if (0 == num) {
        return 1;
    } else if (last_index == 0) {
        return 0;
    }
 
    int left =CheckSumPossibility(num, arr, last_index - 1);
    int right =CheckSumPossibility(num - arr[last_index - 1], arr, last_index - 1);
    return left || right;
}

int main() {
    int arraySize;
    int arr[MAX_SIZE];
    int num;
    int returnVal;
    cin >> arraySize;
    cin >> num;
    for (int i = 0; i < arraySize; ++i) { cin >> arr[i]; }
    returnVal = CheckSumPossibility(num, arr, arraySize);
    if (returnVal == 1) {
        cout << "Possible!" << endl;
    } else {
        cout << "Not possible!" << endl;
    }

    return 0;

}
