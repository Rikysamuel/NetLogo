#define DEBUG

#include <cstdio>
#include <cstring>
#include <cstdlib>
#include <string>
#include <stack>
#include <queue>
#include <deque>
#include <vector>
#include <map>
#include <set>
#include <utility>
#include <algorithm>
#include <cmath>
#include <iostream>
#include <fstream>
#include <sstream>
#include <climits>
#include <ctime>
#include <cassert>
using namespace std;
// template

// abbreviations
#define vi vector <int>
#define vl vector <long long>
#define vb vector <bool>
#define vs vector <string>
#define ii pair <int, int>
#define a first
#define b second
#define vii vector <ii>
#define mii map <int, int>
#define que queue
#define pque priority_queue
#define stk stack
#define lsone(value) (value)&(-value)
#define pub push_back
#define pob pop_back
#define puf push_front
#define pof pop_front
#define pu push
#define po pop
#define mp make_pair
#define loop(i, n) for(int i = 0; i < n; ++i)
#define loop1(i, n) for(int i = 1; i <= n; ++i)
#define reverse_iterate(a, b) for(__typeof(b.rend()) a = b.rbegin(); a != b.rend(); ++a)
#define iterate(a, b) for(__typeof(b.begin()) a = b.begin(); a != b.end(); ++a)
#define all(i) i.begin(), i.end()

typedef unsigned long long ull;
typedef long long ll;

const double PI = acos(-1);

#ifdef DEBUG
	#define debug(...) printf(__VA_ARGS__)
	#define GetTime() fprintf(stderr,"Running time: %.3lf second\n",((double)clock())/CLOCKS_PER_SEC)
#else
	#define debug(...) 
	#define GetTime() 
#endif

// end of template

inline bool check_oob(const vs& grid, ii pos) {
	if ((pos.a < 0) or (pos.a >= grid.size()) or (pos.b < 0) or (pos.b >= grid[0].size()))
		return true;
	return false;
}

struct State {
	ii pos;
	int pattern;
	int cost;
	State(ii pos, int pattern, int cost) : pos(pos), pattern(pattern), cost(cost) {
	}
};

#define N_PATTERN 4

const bool pattern_form[N_PATTERN][9] = {
	{
		false, false, true,
		true, true, true,
		false, false, false
	},
	{
		false, true, false,
		false, true, false,
		false, true, true
	},
	{
		false, false, false,
		true, true, true,
		true, false, false
	},
	{
		true, true, false,
		false, true, false,
		false, true, false
	}
};

const int dir_part_x[] = {-1, 0, 1, -1, 0, 1, -1, 0, 1};
const int dir_part_y[] = {-1, -1, -1, 0, 0, 0, 1, 1, 1};

#define OBS_CHAR '#'

// check if it is over the boundary of map (edge and )
bool is_valid(const vs& grid, State &state) {
	ii &loc = state.pos; 
	int pattern = state.pattern;
	for (int dir_part_idx = 0; dir_part_idx < 9; ++dir_part_idx) {
		if (!pattern_form[pattern][dir_part_idx]) { // there is no part of the object in there
			continue;
		}
		ii new_loc(loc.a+dir_part_y[dir_part_idx], loc.b+dir_part_x[dir_part_idx]);
		if ((check_oob(grid, new_loc)) or (grid[new_loc.a][new_loc.b] == OBS_CHAR))
			return false;

	}
	return true;
}

#define N_DIR_MOV 8
const int mov_x[] = {-1, 0, 1, -1, 1, -1, 0, 1};
const int mov_y[] = {-1, -1, -1, 0, 0, 1, 1, 1};

#define INF INT_MAX

void get_bfs(const vs &grid, const ii &start, vector<vi> *min_cost) {
	for (int pattern_idx = 0; pattern_idx < N_PATTERN; ++ pattern_idx) {
		min_cost[pattern_idx].clear();
		min_cost[pattern_idx].resize(grid.size(), vi(grid[0].size(), INF));
	}

	queue<State> q;
	// initialize the queue
	for (int pattern_idx = 0; pattern_idx < N_PATTERN; ++pattern_idx) {
		State state(start, pattern_idx, 0);
		if (is_valid(grid, state)) {
			q.pu(state);
		}
	}

	while (!q.empty()) {
		State curr_state = q.front();
		q.pop();

		ii &curr_pos = curr_state.pos;
		int &curr_pattern = curr_state.pattern;
		int &curr_cost = curr_state.cost;

		if (curr_cost >= min_cost[curr_pattern][curr_pos.a][curr_pos.b]) // ignore the other bfs that cannot have lower cost than this one
			continue;

		min_cost[curr_pattern][curr_pos.a][curr_pos.b] = curr_cost;

		for (int mov_idx = 0; mov_idx < N_DIR_MOV; ++mov_idx) { // only move doesn't change state
			ii new_pos(curr_pos.a+mov_y[mov_idx], curr_pos.b+mov_x[mov_idx]);
			int new_cost = curr_cost+1; // increase the cost
			State new_state(new_pos, curr_pattern, new_cost);
			if (!is_valid(grid, new_state))
				continue;
			
			if (new_state.cost >= min_cost[curr_pattern][new_pos.a][new_pos.b]) // why you would like to move there which is already better than yours?
				continue;
			q.pu(new_state);
		}

		for (int pattern_idx = 0; pattern_idx < N_PATTERN; ++pattern_idx) {
			if (pattern_idx == curr_pattern) // doesn't need to do the same pattern for current position
				continue;
			State new_state(curr_pos, pattern_idx, curr_cost);
			if (!is_valid(grid, new_state))
				continue;

			if (new_state.cost >= min_cost[pattern_idx][curr_pos.a][curr_pos.b])
				continue;
			q.pu(new_state);
		}
	}
}

State find_start(const vs &grid, char sym_start) {
	int top = INT_MAX, bottom = -1, left = INT_MAX, right = -1;

	for (int i = 0; i < grid.size(); ++i) {
		for (int j = 0; j < grid[i].size(); ++j) {
			if (grid[i][j] != sym_start)
				continue;
			top = min(top, i);
			bottom = max(bottom, i);
			left = min(left, j);
			right = max(right, j);
		}
	}
	if (right-left == 2) {
		int mid = (right+left)/2;
		if (grid[top][mid] == sym_start)
			return State(ii(top, mid), 2, 0);
		else
			return State(ii(bottom, mid), 0, 0);
	} else {
		int mid = (top+bottom)/2;
		if (grid[mid][right] == sym_start)
			return State(ii(mid, right), 3, 0);
		else
			return State(ii(mid, left), 1, 0);
	}
}

char mov_char[] = {'1', '2', '3', '4', '6', '7', '8', '9'};

int main() {
    int n_row, n_col;
    scanf("%d %d%*c", &n_row, &n_col);
    
    vs grid(n_row);
    for (int i = 0; i < n_row; ++i) {
    	cin >> grid[i];
    }

    ii goal;
    // finding goal position, it exist only one in the grid
    for (int i = 0; i < n_row; ++i) {
    	for (int j = 0; j < n_col; ++j) {
	    	if (grid[i][j] == 'G') {
	    		goal = ii(i, j);
	    	}
    	}
    }

    vector<vi> matx_min_cost[4];
    get_bfs(grid, goal, matx_min_cost);

    int n_syms = 4;
    char syms_start[] = {'1', '2', '3', '4'};
    for (int sym_idx = 0; sym_idx < n_syms; ++sym_idx) {
    	char &sym_start = syms_start[sym_idx];
    	string path = "";

    	State state = find_start(grid, sym_start);

    	state.cost = matx_min_cost[state.pattern][state.pos.a][state.pos.b];
    	bool has_rotate = false;
    	while (state.cost > 0) {
    		ii &pos = state.pos;
    		bool can_move = false;
    		// cout << "[" << pos.a << " " << pos.b << "]" << " : " << state.cost << endl;
    		for (int mov_idx = 0; mov_idx < N_DIR_MOV; ++mov_idx) {
    			ii new_pos(pos.a+mov_y[mov_idx], pos.b+mov_x[mov_idx]);
    			if (check_oob(grid, new_pos))
    				continue;
    			if (state.cost > matx_min_cost[state.pattern][new_pos.a][new_pos.b]) {
    				if (has_rotate) {
    					path += ('A'+state.pattern);
    					has_rotate = false;
    				}
    				can_move = true;
    				state.cost = matx_min_cost[state.pattern][new_pos.a][new_pos.b];
    				path += mov_char[mov_idx];
    				state.pos = new_pos;
    				break;
    			}
    		}
    		if (!can_move) {
    			has_rotate = true;
    			state.pattern = (state.pattern+1)%N_PATTERN;
    		}
    	}

    	cout << path << endl; // output answer
    	break;
    }

    // int pattern = 0;

    // for (int i = 0; i < n_row; ++i) {
    // 	for (int j = 0; j < n_col; ++j) {
    // 		if (j)
    // 			printf(" ");
    // 		if (matx_min_cost[pattern][i][j] == INF)
    // 			printf("-");
    // 		else
    // 			printf("%d", matx_min_cost[pattern][i][j]);
    // 	}
    // 	printf("\n");
    // }

    return 0;
}