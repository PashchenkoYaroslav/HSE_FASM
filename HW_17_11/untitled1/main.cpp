#include <iostream>
#include <thread>
#include <vector>
#include <string>

using namespace std;

const int numberOfGreatGrandsons = 8;
const string DonMes = "Enter the legacy of don Enrique :";
const string OffspringMes = "Enter inheritance of offspring number ";
const string ProduceWarning = "Invalid input: you must enter a number greater than zero with the type long long int \n";

void UniteFractions(long long int &actualHeritage,
                    vector<long long int> receivedHeritage, int generation, int numberOfHeir) {
    generation--;
    if (generation >= 1) {
        thread thr_1(UniteFractions, ref(actualHeritage), receivedHeritage, generation, numberOfHeir);
        thread thr_2(UniteFractions, ref(actualHeritage), receivedHeritage, generation,
                     numberOfHeir + pow(2, generation - 1));
        thr_1.join();
        thr_2.join();
    } else {
        actualHeritage -= receivedHeritage[numberOfHeir];
    }
}

long long int ProduceNumber(const string &mes) {
    cout << mes << "\n";
    long long int num;
    while (!(cin >> num) || num < 0) {
        cin.clear();
        cin.ignore(cin.rdbuf()->in_avail());
        cout << ProduceWarning;
    }
    return num;
}

int main() {
    long long int actualHeritage;
    vector<long long int> receivedHeritage(numberOfGreatGrandsons);
    try {
        actualHeritage = ProduceNumber(DonMes);
        for (int i = 0; i < numberOfGreatGrandsons; ++i) {
            receivedHeritage[i] = ProduceNumber(OffspringMes + to_string(i));
        }
        thread thr(UniteFractions, ref(actualHeritage), receivedHeritage, 4, 0);
        thr.join();
        cout << (actualHeritage == 0 ? "Don Hose is completely honest!" : "Don Hose is dishonest with us");
    }
    catch (exception e) {
        cout << e.what();
    }
    return 0;
}