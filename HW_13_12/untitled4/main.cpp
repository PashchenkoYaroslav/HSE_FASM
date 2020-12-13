#include <iostream>
#include <vector>
#include <ctime>
#include <unistd.h>
#include <thread>
#include <sstream>

int const NUMBER_OF_VISITORS_PER_DAY = 100;
int const MAX_COUNT_OF_VISITORS = 50;
int const MAX_COUNT_OF_VIEWERS_BY_PICTURE = 11;
using namespace std;

class ArtGallery {
public:
    int _countOfVisitors;
    vector<int> _countOfViewersByPicture;

    ArtGallery() {
        _countOfVisitors = 0;
        _countOfViewersByPicture = {0, 0, 0, 0, 0};
    }

    ~ArtGallery() = default;
};

void static TryToLook(ArtGallery &artGallery, int numOfThr, bool isFirstTime, int chosedArt) {
    sleep(2);
    srand(numOfThr + time(nullptr));
    int picture;
    string mes;
    mes = "Visitor number " + to_string(numOfThr);
    if (isFirstTime) {
        string extraMes = mes + " went to the art gallery\n";
        cout << extraMes;
        picture = rand() / ((RAND_MAX + 1u) / 5);
        artGallery._countOfVisitors++;
    } else if (chosedArt == -1) {
        picture = rand() / ((RAND_MAX + 1u) / 8);
    }
    if (picture >= 0 && picture <= 4) {
        if (artGallery._countOfViewersByPicture[picture] < MAX_COUNT_OF_VIEWERS_BY_PICTURE) {
            artGallery._countOfViewersByPicture[picture]++;
            mes += " looking at the picture number " + to_string(picture) + "\n";
            cout << mes;
            sleep(2);
            artGallery._countOfViewersByPicture[picture]--;
            TryToLook(ref(artGallery), numOfThr, false, -1);
        } else {
            mes += " waiting for the opportunity to look at the painting number " + to_string(picture) + "\n";
            cout << mes;
            sleep(2);
            TryToLook(ref(artGallery), numOfThr, false, picture);
        }
    } else {
        artGallery._countOfVisitors--;
        mes += " leaves the gallery\n";
        cout << mes;
        sleep(2);
    }
}

int main() {
    thread visitors[NUMBER_OF_VISITORS_PER_DAY];
    ArtGallery artGallery;
    try {
        for (int i = 0; i < NUMBER_OF_VISITORS_PER_DAY; ++i) {
            sleep(1);
            if (artGallery._countOfVisitors < MAX_COUNT_OF_VISITORS) {
                visitors[i] = thread(TryToLook, ref(artGallery), i, true, -1);
            } else {
                sleep(1);
                --i;
            }
        }
        for (auto &visitor : visitors) {
            visitor.join();
        }
    }
    catch (exception e) {
        cout << e.what();
    }
    return 0;
}