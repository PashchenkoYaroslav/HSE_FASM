#include <iostream>
#include <thread>
#include <vector>
#include <string>
#include <fstream>
#include <omp.h>
#include <cstdlib>
#include <numeric>

using namespace std;

const string honestAns = "Don Hose is completely honest! Descendant number : ";
const string greedyAns = "Don Hose stole some of the money! Descendant number : ";
const string generousAns = "Don Hose added a little to the money! Descendant number : ";
const string errorMes = "An unexpected error occurred! Descendant number : ";
const string exceptionMes = "Runtime exception occurred!";
const int numberOfHeirs = 8;

struct Testament {
    long long int heritageSumm;
    vector<double> shareOfInheritance;
    vector<long long int> receivedHeritage;
    vector<int> honestyIndicators;
};

void ReadInfo(Testament &testament, const string &path) {
    basic_string<char> temp;
    ifstream in(path);
    if (!in)
        throw invalid_argument("File access exception occurred");
    in >> temp;
    testament.heritageSumm = stoi(temp);
    while (!in.eof() && in) {
        for (int i = 0; i < numberOfHeirs; i++) {
            testament.honestyIndicators.push_back(-1);
            in >> temp;
            testament.receivedHeritage.push_back(stoi(temp));
        }
        for (int i = 0; i < numberOfHeirs; i++) {
            in >> temp;
            testament.shareOfInheritance.push_back(atof(temp.c_str()));
            if (i == 6 && in.eof())
                throw invalid_argument("Incorrect number of parameters");
        }
    }
    in.close();

}

void CheckHonesty(Testament &testament, int numberOfHeir) {
    long long int actualSumm = testament.shareOfInheritance[numberOfHeir] * testament.heritageSumm;
    if (testament.receivedHeritage[numberOfHeir] == actualSumm)
        testament.honestyIndicators[numberOfHeir] = 1;
    else if (testament.receivedHeritage[numberOfHeir] < actualSumm)
        testament.honestyIndicators[numberOfHeir] = 2;
    else if (testament.receivedHeritage[numberOfHeir] > actualSumm)
        testament.honestyIndicators[numberOfHeir] = 3;
    else
        testament.honestyIndicators[numberOfHeir] = -1;
}

void CheckValidity(Testament &testament) {
    for (int i = 0; i < numberOfHeirs; ++i) {
        if (testament.shareOfInheritance[i] > 1 || testament.shareOfInheritance[i] < 0)
            throw invalid_argument("Incorrect share");
        if (testament.receivedHeritage[i] < 0)
            throw invalid_argument("Incorrect descendant's heritage");
        if (testament.heritageSumm < 0)
            throw invalid_argument("Incorrect summa of heritage");
        if (accumulate(testament.shareOfInheritance.begin(), testament.shareOfInheritance.end(), 0.0f) > 1)
            throw invalid_argument("Share summa cannot be more than 1");
    }
}


void UniteFractions(Testament &testament, int generation) {
#pragma omp parallel
    {
        generation--;
        if (generation >= 1) {
            thread thr_1(UniteFractions, ref(testament), generation);
            thread thr_2(UniteFractions, ref(testament), generation);
            thr_1.join();
            thr_2.join();
        } else {
            CheckHonesty(ref(testament), omp_get_thread_num());
        }
    }
}

void WriteAnswer(Testament testament, const string &path) {
    ofstream out(path);
    for (int i = 0; i < numberOfHeirs; ++i) {
        switch (testament.honestyIndicators[i]) {
            case 1:
                out << honestAns + to_string(i) << endl;
                break;
            case 2:
                out << greedyAns + to_string(i) << endl;
                break;
            case 3:
                out << generousAns + to_string(i) << endl;
                break;
            default:
                out << errorMes + to_string(i) << endl;
                break;
        }
    }
    out.close();
}

void BugReport(const string &path, const string &mes) {
    ofstream out(path);
    out << mes;
    out.close();
}

int main(int argc, char *argv[]) {
    try {
        omp_set_num_threads(2);
        Testament testament;
        ReadInfo(ref(testament), argv[1]);
        CheckValidity(testament);
        UniteFractions(ref(testament), 4);
        WriteAnswer(testament, argv[2]);
    }
    catch (exception &e) {
        cout << e.what() << endl;
        BugReport(argv[2], e.what());
    }
    catch (...) {
        cout << exceptionMes << endl;
        BugReport(argv[2], exceptionMes);
    }
}