module MyModule::TokenFaucet {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing the faucet.
    struct Faucet has store, key {
        distribution_amount: u64,  // Amount of tokens to distribute per request
    }

    /// Function to create a faucet with a specified token distribution amount.
    public fun create_faucet(owner: &signer, distribution_amount: u64) {
        let faucet = Faucet {
            distribution_amount,
        };
        move_to(owner, faucet);
    }

    /// Function to request tokens from the faucet.
    public fun request_tokens(user: &signer, faucet_owner: address) acquires Faucet {
        let faucet = borrow_global<Faucet>(faucet_owner);

        // Transfer tokens from the faucet owner to the user
        let tokens = coin::withdraw<AptosCoin>(user, faucet.distribution_amount);
        coin::deposit<AptosCoin>(signer::address_of(user), tokens);
    }
}
