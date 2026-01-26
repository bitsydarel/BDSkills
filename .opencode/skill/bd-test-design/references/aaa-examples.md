# AAA Examples

Code examples demonstrating the Arrange-Act-Assert pattern across different test types and platforms.

## Unit Test Example (JavaScript with Jest)

```javascript
describe('UserService', () => {
  test('should create user with valid data', () => {
    // Arrange
    const userService = new UserService();
    const userData = { name: 'John Doe', email: 'john@example.com' };

    // Act
    const user = userService.createUser(userData);

    // Assert
    expect(user.id).toBeDefined();
    expect(user.name).toBe('John Doe');
    expect(user.email).toBe('john@example.com');
  });
});
```

## Integration Test Example (Python with pytest)

```python
def test_user_registration_flow(user_api_client, db_session):
    # Arrange
    user_data = {'username': 'testuser', 'password': 'secure123'}

    # Act
    response = user_api_client.post('/register', json=user_data)

    # Assert
    assert response.status_code == 201
    user = db_session.query(User).filter_by(username='testuser').first()
    assert user is not None
    assert user.is_active is True
```

## E2E Test Example (TypeScript with Playwright)

```typescript
test('user can register and login', async ({ page }) => {
  // Arrange - navigate to registration page
  await page.goto('/register');

  // Act - fill form and submit
  await page.fill('[data-testid="username"]', 'e2euser');
  await page.fill('[data-testid="password"]', 'password123');
  await page.click('[data-testid="register-button"]');

  // Assert - redirected to dashboard and logged in
  await expect(page).toHaveURL('/dashboard');
  await expect(page.locator('[data-testid="welcome-message"]')).toContainText('e2euser');
});
```