import { GraphQLClient, gql } from 'graphql-request';

// Define the GraphQL endpoint
const endpoint = 'https://api.cartridge.gg/x/checkers/torii/graphql';

// Create an instance of GraphQLClient
const graphQLClient = new GraphQLClient(endpoint);

// Define the query as a string
const query = gql`
  query GetId {
    checkersMarqCounterModels {
      edges {
        node {
          nonce
        }
      }
    }
  }
`;

// Define a function to fetch data
export async function fetchData() {
  try {
    // Send the query
    const data = await graphQLClient.request(query);
    // Extract the nonce from the response
    //@ts-ignore
    const hexNonce = data.checkersMarqCounterModels.edges[0].node.nonce;
    // Convert nonce to decimal
    const assignedSessionId = parseInt(hexNonce, 16) - 1;
    console.log('Assigned session id', assignedSessionId);
  } catch (error) {
    console.error('Error fetching data:', error);
  }
}
