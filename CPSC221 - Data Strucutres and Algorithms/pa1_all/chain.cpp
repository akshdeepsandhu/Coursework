#include "chain.h"
#include "chain_given.cpp"

// PA1 functions

/**
 * Destroys the current Chain. This function should ensure that
 * memory does not leak on destruction of a chain.
 */
Chain::~Chain() {
   clear();
}

/**
 * Inserts a new node in position one of the Chain,
 * after the sentinel node.
 * This function **SHOULD** create a new Node.
 *
 * @param ndata The data to be inserted.
 */
void Chain::insertFront(const Block &ndata) {
   Node *newNode = new Node(ndata);
   newNode->next = head_->next;
   newNode->next->prev = newNode;
   head_->next = newNode;
   newNode->prev = head_;
   length_++;
}

/**
 * Inserts a new node at the back of the Chain,
 * but before the tail sentinel node.
 * This function **SHOULD** create a new ListNode.
 *
 * @param ndata The data to be inserted.
 */
void Chain::insertBack(const Block &ndata) {
   Node *newNode = new Node(ndata);
   newNode->next = tail_;
   newNode->prev = tail_->prev;
   newNode->next->prev = newNode;
   newNode->prev->next = newNode;
   length_++;

}

/**
 * Modifies the Chain by moving a contiguous subset of Nodes to
 * the end of the chain. The subset of len nodes from (and
 * including) startPos are moved so that they
 * occupy the last len positions of the
 * chain (maintaining the sentinel at the end). Their order is
 * not changed in the move.
 */
void Chain::moveToBack(int startPos, int len) {
   if (startPos == 0) {
      startPos++;
   }
   if (len > length_) {
      cout << "moveToBack called with too large length." << endl;
      return;
   }

   Node *before = walk(head_, startPos - 1);
   Node *after = walk(before, len + 1);
   if (after == tail_ || len == 0) {
      return;
   }
   Node *first = before->next;
   Node *last = after->prev;

   before->next = after;
   after->prev = before;
   first->prev = tail_->prev;
   last->next = tail_;
   tail_->prev = last;
   first->prev->next = first;

}

/**
 * Rotates the current Chain by k nodes: removes the first
 * k nodes from the Chain and attaches them, in order, at
 * the end of the chain (maintaining the sentinel at the end).
 */
void Chain::rotate(int k) {
   moveToBack(1, k);
}

/**
 * Modifies the current chain by swapping the Node at pos1
 * with the Node at pos2. the positions are 1-based.
 */
void Chain::swap(int pos1, int pos2) {
   if (pos1 > length_ || pos2 > length_ || pos1 < 1 || pos2 < 1) {
      cerr << "pos1/pos2 out of bounds of chain for swap" << endl;
      return;
   }

   Node *first = walk(head_, pos1);
   Node *second = walk(head_, pos2);
   first->prev->next = second;
   second->next->prev = first;
   Node *temp = second->next;
   second->next = first->next;
   first->next = temp;
   temp = second->prev;
   second->prev = first->prev;
   second->next->prev = second;
   first->prev = temp;
   first->prev->next = first;
}

/*
 *  Modifies both the current and input chains by trading
 * nodes in even positions between the chains. Length
 * of each chain should stay the same. If the block dimensions
 * are NOT the same, the funtion has no effect and a simple
 * error message is output: cout << "Block sizes differ." << endl;
 */

void Chain::twist(Chain &other) {
   auto swapNodes = [](Node* node1, Node* node2) {
      Node *chain1_prev = node1->prev;
      Node *chain1_next = node1->next;
      Node *chain2_prev = node2->prev;
      Node *chain2_next = node2->next;

      node1->prev = chain2_prev;
      node1->next = chain2_next;
      node2->prev = chain1_prev;
      node2->next = chain1_next;

      chain1_prev->next = node2;
      chain1_next->prev = node2;
      chain2_prev->next = node1;
      chain2_next->prev = node1;
   };

   if (width_ != other.width_|| height_ != other.height_) {
      cout << "Block sizes differ" << endl;
      return;
   }
   Node *curr1 = head_->next;
   Node *curr2 = other.head_->next;
   for (int i = 1; i <= std::min(length_, other.length_); i++) {
      if (i % 2 == 0) {
         swapNodes(curr1, curr2);
      }
      curr1 = curr1->next;
      curr2 = curr2->next;
   }
}

/**
 * Destroys all dynamically allocated memory associated with the
 * current Chain class.
 */

void Chain::clear() {
   while (head_ != NULL) {
      Node *next = head_->next;
      delete head_;
      head_ = next;
   }
   tail_ = NULL;
   length_ = 0;
   width_ = 0;
   height_ = 0;
}

/* makes the current object into a copy of the parameter:
 * All member variables should have the same value as
 * those of other, but the memory should be completely
 * independent. This function is used in both the copy
 * constructor and the assignment operator for Chains.
 */

void Chain::copy(Chain const &other) {
   head_ = new Node();
   tail_ = new Node();
   head_->next = tail_;
   tail_->prev = head_;
   length_ = 0;
   for (const Node *curr = other.head_->next; curr->next != NULL; curr = curr->next) {
      insertBack(curr->data);
   }
   height_ = other.height_;
   width_ = other.width_;
}


