import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoriteProvider = StateNotifierProvider<FavoriteNotifier, Set<String>>((ref) {
    return FavoriteNotifier();
});

class FavoriteNotifier extends StateNotifier<Set<String>> {
    FavoriteNotifier() : super(<String>{});

    void addFavorite(String name) {
        state = {...state, name};
    }

    void removeFavorite(String name) {
        state = Set.from([...state]..remove(name));
    }

    void switchFavorite(String name) {
        if (isFavorite(name)) {
            removeFavorite(name);
        } else {
            addFavorite(name);
        }
    }

    List<String> getAllFavorites() {
        return state.toList();
    }

    bool isFavorite(String name) {
        return state.contains(name);
    }
}